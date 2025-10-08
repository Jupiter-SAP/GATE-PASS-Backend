CLASS zcl_http_gatenrgp DEFINITION
  PUBLIC
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.

    TYPES: BEGIN OF ty_payload,
             header TYPE zgate_nrgp_hdr,
             items  TYPE STANDARD TABLE OF zgate_nrgp_item WITH DEFAULT KEY,
           END OF ty_payload.

    TYPES: BEGIN OF resp_type,
             postnumber TYPE c LENGTH 30,
             docnumber  TYPE c LENGTH 30,
           END OF resp_type.
    CLASS-METHODS get_cid
      RETURNING VALUE(cid) TYPE abp_behv_cid.
ENDCLASS.



CLASS zcl_http_gatenrgp IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DELETE FROM zgate_nrgp_hdr.
    DELETE FROM zgate_nrgp_item.
  ENDMETHOD.


  METHOD if_http_service_extension~handle_request.

    SELECT FROM i_materialdocumentheader_2 AS a
    LEFT JOIN i_materialdocumentitem_2 AS b ON b~materialdocument = a~materialdocument
    LEFT JOIN i_producttext AS c ON c~product = b~material AND c~language = 'E'
    FIELDS a~materialdocument INTO TABLE @DATA(itt) PRIVILEGED ACCESS.

    DATA: lv_method TYPE string,
          ls_data   TYPE ty_payload,
          lv_msg    TYPE string.

    lv_method = request->get_method( ).
    DATA(req) = request->get_form_fields(  ).
    DATA(shipped) =  VALUE #( req[ name = 'shipped' ]-value OPTIONAL ) .

    DATA(lv_data) = request->get_text( ).

    TRY.
        /ui2/cl_json=>deserialize(
        EXPORTING
          json = lv_data
        CHANGING
          data = ls_data
      ).

        CASE lv_method.
          WHEN 'POST'.
            IF shipped = 'false'.

              TRY.
                  DATA ls_header TYPE zgate_nrgp_hdr.
                  DATA ls_db_item TYPE zgate_nrgp_item.

                  ls_header = CORRESPONDING zgate_nrgp_hdr( ls_data-header ).
                  ls_header-document_no = ls_header-document_no.
                  ls_header-created_by = cl_abap_context_info=>get_user_technical_name( ).
                  MODIFY zgate_nrgp_hdr FROM @ls_header.

                  LOOP AT ls_data-items INTO DATA(ls_item).
                    ls_db_item = CORRESPONDING zgate_nrgp_item( ls_item ).
                    ls_db_item-document_no = ls_header-document_no.
                    ls_db_item-created_by  = cl_abap_context_info=>get_user_technical_name( ).
                    MODIFY zgate_nrgp_item FROM @ls_db_item.
                  ENDLOOP.

                  COMMIT WORK.
                  lv_msg = | { ls_header-document_no } |.

                CATCH cx_root INTO DATA(lx).
                  lv_msg = |Error: { lx->get_text( ) }|.
              ENDTRY.
              response->set_text( lv_msg ).

            ELSE.
              TRY.
                  ls_header = ls_data-header.
                  cl_numberrange_runtime=>number_get(
                         EXPORTING
                           nr_range_nr = '1'
                           object      = 'ZNR_NRGP_P'
                         IMPORTING
                           number      = DATA(postnum)
                       ).

                  DATA it_final TYPE TABLE OF zgate_nrgp_item.
                  DATA wa_nrgp TYPE zgate_nrgp_item.

                  LOOP AT ls_data-items INTO DATA(ls_item1).
                    wa_nrgp-document_no = ls_data-header-document_no.
                    wa_nrgp-line_no     = ls_item1-line_no.
                    wa_nrgp-nrgp_no     = postnum.
                    wa_nrgp-nrgp_line_no = ls_item1-line_no.
                    wa_nrgp-product     = ls_item1-product.
                    wa_nrgp-quantity    = ls_item1-quantity.
                    wa_nrgp-batch       = ls_item1-batch.
                    wa_nrgp-cost_center = ls_item1-cost_center.

                    SELECT SINGLE FROM i_unitofmeasuretext AS a FIELDS a~unitofmeasure
                    WHERE a~unitofmeasurecommercialname = @ls_item1-unit AND a~language = 'E'
                    INTO @DATA(lv_unit) PRIVILEGED ACCESS.
                    wa_nrgp-unit     = lv_unit.
                    APPEND  wa_nrgp TO it_final.
                    CLEAR : lv_unit, wa_nrgp.
                  ENDLOOP.

                  MODIFY ENTITIES OF i_materialdocumenttp
                      ENTITY materialdocument
                        CREATE FROM VALUE #(
                          ( %cid                       = 'CID_001'
                            goodsmovementcode          = '03'
                            postingdate                = cl_abap_context_info=>get_system_date( )
                            documentdate               = cl_abap_context_info=>get_system_date( )
                            %control-goodsmovementcode = cl_abap_behv=>flag_changed
                            %control-postingdate       = cl_abap_behv=>flag_changed
                            %control-documentdate      = cl_abap_behv=>flag_changed ) )

                      ENTITY materialdocument
                        CREATE BY \_materialdocumentitem
                        FROM VALUE #( (
                               %cid_ref = 'CID_001'
                               %target = VALUE #( FOR wa_final IN it_final INDEX INTO i  ( %cid   = |CID_{ i }_001|
                                plant                        = ls_header-plant
                                storagelocation              = ls_header-from_storage_loc
                                material                     = wa_final-product
                                goodsmovementtype            = '201'
                                quantityinentryunit          = wa_final-quantity
                                entryunit                    = wa_final-unit
                                costcenter                   = wa_final-cost_center
                                batch                        = wa_final-batch
                                %control-plant               = cl_abap_behv=>flag_changed
                                %control-storagelocation     = cl_abap_behv=>flag_changed
                                %control-material            = cl_abap_behv=>flag_changed
                                %control-goodsmovementtype   = cl_abap_behv=>flag_changed
                                %control-quantityinentryunit = cl_abap_behv=>flag_changed
                                %control-entryunit           = cl_abap_behv=>flag_changed
                                %control-costcenter          = cl_abap_behv=>flag_changed
                                %control-batch               = cl_abap_behv=>flag_changed ) ) ) )
                      MAPPED   DATA(ls_create_mapped)
                      FAILED   DATA(ls_create_failed)
                      REPORTED DATA(ls_create_reported).

                  COMMIT ENTITIES BEGIN
                  RESPONSE OF i_materialdocumenttp
                  FAILED DATA(commit_failed)
                  REPORTED DATA(commit_reported).
                  COMMIT ENTITIES END.

                  SELECT FROM zgate_nrgp_item
                  FIELDS document_no, line_no
                  WHERE document_no = @ls_header-document_no
                  INTO TABLE @DATA(it_doc).

                  DATA(nrgp_date) = cl_abap_context_info=>get_system_date( ) .

*                  LOOP AT it_doc INTO DATA(ls_doc).
*
*                    UPDATE zgate_nrgp_item
*                    SET nrgp_no = @postnum ,
*                    nrgp_line_no = @ls_doc-line_no,
*                    nrgp_date     = @nrgp_date
*                    WHERE document_no = @ls_doc-document_no
*                    AND line_no = @ls_doc-line_no.
*                  ENDLOOP.

                  IF commit_failed IS INITIAL AND ls_create_failed IS INITIAL.

                    DATA(lv_matdoc) = commit_reported-materialdocumentitem[ 1 ]-materialdocument.
                  ENDIF.
                  DATA lv_postnum TYPE string.
                  lv_postnum = |{ postnum }|.

                  DATA(response_text) = VALUE resp_type(
                    docnumber = lv_matdoc
                    postnumber = lv_postnum ).

                  DATA(lv_json) = /ui2/cl_json=>serialize( response_text ).
                  response->set_text( lv_json ).
                CATCH cx_root INTO DATA(ly).
                  lv_msg = |Error: { ly->get_text( ) }|.
                  response->set_text( lv_msg ).
              ENDTRY.
            ENDIF.




          WHEN 'GET'.
            TRY.
                cl_numberrange_runtime=>number_get(
                  EXPORTING
                    nr_range_nr = '1'
                    object      = 'ZNRO_NRGP'
                  IMPORTING
                    number      = DATA(nextnumber1)
                ).
              CATCH cx_number_ranges INTO DATA(lx_number_ranges1).
                DATA(lv_error_msg1) = lx_number_ranges1->get_text( ).
                response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
                response->set_text( 'Only GET method is allowed' ).

            ENDTRY.

            DATA(lv_result1) = |{ nextnumber1 }| .

            TRY .
                DATA(lv_nrgpno1) =  /ui2/cl_json=>serialize( data = lv_result1 ).
                response->set_status( i_code = 200 i_reason = 'OK' ).
                response->set_header_field( i_name = 'Content-Type' i_value = 'application/json' ).
                response->set_text( lv_nrgpno1 ).
              CATCH cx_root INTO DATA(lx_roots1).
                response->set_status( i_code = 500 i_reason = 'Number Range Error' ).
                response->set_text( lx_roots1->get_text( ) ).
            ENDTRY.
          WHEN OTHERS.
            response->set_status( i_code = 405 i_reason = 'Method Not Allowed' ).
        ENDCASE.
      CATCH cx_root INTO DATA(lx_root).
        lv_msg = |Error: { lx->get_text( ) }|.
    ENDTRY.
  ENDMETHOD.


  METHOD get_cid.
    TRY.
        cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        cid = 'CID_ERROR'.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
