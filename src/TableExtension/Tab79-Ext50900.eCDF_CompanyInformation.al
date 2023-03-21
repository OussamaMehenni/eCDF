#pragma warning disable DOC0101
/// <summary>
/// TableExtension Luxembourg Setup (ID 50900) extends Record Company Information.
/// </summary>
tableextension 50900 "Luxembourg Setup" extends "Company Information"
#pragma warning restore DOC0101
{
    Caption = 'Company Information';

    fields
    {
        field(50900; "Luxembourg Legislation"; Boolean)
        {
            Caption = 'Luxembourg Legislation';
            DataClassification = CustomerContent;
        }
        field(50901; "RCS Enterprise Number"; Code[50])
        {
            Caption = 'RCS Company Number';
            DataClassification = CustomerContent;
        }
        field(50902; AMatrnb; Code[20])
        {
            Caption = 'Agent Register No.';
            DataClassification = CustomerContent;
        }
        field(50903; ARCSnbr; Code[10])
        {
            Caption = 'RCS Agent No.';
            DataClassification = CustomerContent;
        }
        field(50904; AVATNbr; Code[30])
        {
            Caption = 'Agent VAT No.';
            DataClassification = CustomerContent;
        }
        field(50905; DMatrnb; Code[20])
        {
            Caption = 'Declarant Register No.';
            DataClassification = CustomerContent;
        }
        field(50906; DRCSnbr; Code[10])
        {
            Caption = 'Declarant RCS No.';
            DataClassification = CustomerContent;
        }
        field(50907; DVATNbr; Code[30])
        {
            Caption = 'Declarant VAT No.';
            DataClassification = CustomerContent;
        }
        field(50908; "eCDF - Prefix"; Code[6])
        {
            Caption = 'eCDF - Prefix';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                PrefixLen: Integer;
                Text50900: Label 'must contain excatly %1 characters';
            begin
                PrefixLen := 6;
                if (StrLen("eCDF - Prefix") <> PrefixLen) then
                    FieldError("eCDF - Prefix", StrSubstNo(Text50900, PrefixLen));
            end;
        }
        field(50909; "Diplo. VAT Bus. Posting Origin"; Code[20])
        {
            Caption = 'Diplomat : Origin VAT Bus. Posting Group';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(50910; "Diplo. VAT Bus. Posting Exo"; Code[20])
        {
            Caption = 'Diplomat : VAT Bus. Posting Group exoneration';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(50911; "Diplo. Threshold Amount"; Decimal)
        {
            Caption = 'Threshold Amount( Diplomat)';
            DataClassification = CustomerContent;
        }

        field(50912; "Declaration Intrastat Type"; Option)
        {
            Caption = 'Declaration Intrastat Type';
            OptionMembers = Simplified,Detailed;
            OptionCaption = 'Simplified,Detailed';
            DataClassification = CustomerContent;
        }

        field(50913; "TaxationSystem"; Option)
        {
            Caption = 'Taxation System';
            OptionMembers = Sales,Receipts;
            OptionCaption = 'Sales,Receipts';
            DataClassification = CustomerContent;

        }

        field(50914; "eCDF - XSD File"; Text[250])
        {
            Caption = 'eCDF - XSD File';
            DataClassification = CustomerContent;
        }
        field(50915; "eCDF - XML Version"; Option)
        {
            Caption = 'eCDF - XML Version';
            OptionCaption = 'XML 1.1,XML 2.0';
            OptionMembers = "XML 1.1","XML 2.0";
            DataClassification = CustomerContent;
        }
    }
}