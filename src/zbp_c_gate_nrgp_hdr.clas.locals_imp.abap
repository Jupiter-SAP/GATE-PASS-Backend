CLASS lhc_zc_gate_nrgp_hdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR zc_gate_nrgp_hdr
        RESULT result.

ENDCLASS.

CLASS lhc_zc_gate_nrgp_hdr IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
