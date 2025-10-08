CLASS zcl_rgp_driver_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

*    INTERFACES if_oo_adt_classrun.

    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : xml_file TYPE string .

    TYPES :
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct."n

    CLASS-METHODS :
      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check ,

      read_posts
        IMPORTING
                  lv_po2          TYPE string
*                  company_code     TYPE string
        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.jp10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://dev-tcul4uw9.authentication.jp10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS lc_template_name TYPE string VALUE 'zmm_rgp_print/zmm_rgp_print'.

ENDCLASS.



CLASS ZCL_RGP_DRIVER_CLASS IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD.


  METHOD read_posts.


*  ENDMETHOD.
*  METHOD if_oo_adt_classrun~main.


    "DATA: wa_header TYPE zgate_rgp_hdr.
    "  HEADER FIELDS
    SELECT   SINGLE
    FROM  zgate_rgp_hdr  AS a
    LEFT OUTER JOIN  i_supplier AS b
    ON a~partner_code  = b~supplier

    FIELDS
     a~rgp_no,
     a~rgp_date,
     a~partner_name  ,
     a~address1,
     a~address2,
     a~plant,
     a~expected_date,
     b~taxnumber3
     WHERE a~document_no = 'DOC00024'
     INTO @DATA(wa_header)
     PRIVILEGED ACCESS.
    CONCATENATE  wa_header-address1  wa_header-address2   INTO     DATA(lv_address)  SEPARATED BY ',' .

    "  ITEM FILDS
    SELECT
    FROM zgate_rgp_item
    FIELDS
    weight,
    description
    INTO TABLE @DATA(it_item)
    PRIVILEGED ACCESS.

    DATA(lv_xml) =
      |<FORM>| &&
      |<Header>| &&
      |<GatePassNo>{ wa_header-rgp_no }</GatePassNo>| &&
      |<GatePassDate>{ wa_header-rgp_date }</GatePassDate>| &&
      |<VendorName>{ wa_header-partner_name }</VendorName>| &&
      |<VendorAddress>{ lv_address }</VendorAddress>| &&
      |<VendorGST>{ wa_header-taxnumber3 }</VendorGST>| &&
      |<PLANT>{ wa_header-plant }</PLANT>| &&
      |<ExpReturnDate>{ wa_header-expected_date }</ExpReturnDate>| &&
      |</Header>| &&
      |<ITEMS>|.

    LOOP AT it_item INTO DATA(wa_item).
      lv_xml = lv_xml &&
        |<Item>| &&
        |<GatePassNo>{ wa_header-rgp_no }</GatePassNo>| &&
        |<Weight>{ wa_item-weight }</Weight>| &&
        |<Description>{ wa_item-description }</Description>| &&
        |</Item>|.
    ENDLOOP.

    lv_xml = lv_xml &&
      |</ITEMS>| &&
      |</FORM>|.

    CALL METHOD zcl_ads_print=>getpdf(
      EXPORTING
        xmldata  = lv_xml
        template = lc_template_name
      RECEIVING
        result   = result12 ).

*    out->write( lv_xml ).
  ENDMETHOD.
ENDCLASS.
