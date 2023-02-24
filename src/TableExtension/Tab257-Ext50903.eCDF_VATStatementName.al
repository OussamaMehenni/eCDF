

/// <summary>
/// TableExtension VAT Statement Name_Ext (ID 50903) extends Record VAT Statement Name.
/// </summary>
tableextension 50903 "VAT Statement Name_Ext" extends "VAT Statement Name"

{
    Caption = 'VAT Statement Name';
    fields
    {
        field(50900; "Statement eCDF Type"; Option)
        {
            OptionMembers = CA_BILAN,CA_BILANABR,CA_COMPP,CA_COMPPABR,CA_PLANCOMPTA,TVA_DECM,TVA_DECT,TVA_DECA,TVA_DECAS,TVA_LICM,TVA_LICT,TVA_PSIM,TVA_PSIT,AN_TABACAM;
            OptionCaption = 'CA_BILAN,CA_BILANABR,CA_COMPP,CA_COMPPABR,CA_PLANCOMPTA,TVA_DECM,TVA_DECT,TVA_DECA,TVA_DECAS,TVA_LICM,TVA_LICT,TVA_PSIM,TVA_PSIT,AN_TABACAM';
            trigger OnValidate()
            var
            begin
                case "Statement eCDF Type" of
                    "Statement eCDF Type"::TVA_DECA,
                    "Statement eCDF Type"::TVA_DECAS,
                    "Statement eCDF Type"::CA_BILAN,
                    "Statement eCDF Type"::CA_BILANABR,
                    "Statement eCDF Type"::CA_COMPP,
                    "Statement eCDF Type"::CA_COMPPABR,
                    "Statement eCDF Type"::CA_PLANCOMPTA:
                        Validate(Periodicity, Periodicity::Yearly);
                    "Statement eCDF Type"::TVA_DECM,
                    "Statement eCDF Type"::TVA_LICM,
                    "Statement eCDF Type"::TVA_PSIM:
                        Validate(Periodicity, Periodicity::Monthly);
                    "Statement eCDF Type"::TVA_DECT,
                    "Statement eCDF Type"::TVA_LICT,
                    "Statement eCDF Type"::TVA_PSIT:
                        Validate(Periodicity, Periodicity::Quaterly);
                end;
            end;

        }

        field(50901; "Periodicity"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionMembers = Monthly,Quaterly,Yearly;
            OptionCaption = 'Monthly,Quaterly,Yearly';
        }
    }
}