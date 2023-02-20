

/// <summary>
/// TableExtension VAT Statement Name_Ext (ID 50903) extends Record VAT Statement Name.
/// </summary>
tableextension 50903 "VAT Statement Name_Ext" extends "VAT Statement Name"

{
    Caption = 'VAT Statement Name_Ext';
    fields
    {
        field(50900; "Statement eCDF Type"; Option)
        {
            OptionMembers = CA_BILAN,CA_BILANABR,CA_COMPP,CA_COMPPABR,CA_PLANCOMPTA,TVA_DECM,TVA_DECT,TVA_DECA,TVA_DECAS,TVA_LICM,TVA_LICT,TVA_PSIM,TVA_PSIT,AN_TABACAM;

            OptionCaption = 'CA_BILAN,CA_BILANABR,CA_COMPP,CA_COMPPABR,CA_PLANCOMPTA,TVA_DECM,TVA_DECT,TVA_DECA,TVA_DECAS,TVA_LICM,TVA_LICT,TVA_PSIM,TVA_PSIT,AN_TABACAM';

        }
    }
}