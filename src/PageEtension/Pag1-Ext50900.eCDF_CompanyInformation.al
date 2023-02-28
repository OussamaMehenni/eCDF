#pragma warning disable DOC0101
/// <summary>
/// PageExtension Luxembourg Setup (ID 50900) extends Record Company Information.
/// </summary>
pageextension 50900 "Luxembourg Setup" extends "Company Information"
#pragma warning restore DOC0101
{
    Caption = 'Company Information';

    layout
    {
        addafter("User Experience")
        {
            group(Luxembourg)
            {
                Caption = 'Luxembourg';
                field("Luxembourg Legislation"; Rec."Luxembourg Legislation")
                {
                    ApplicationArea = All;
                    Caption = 'Luxembourg Legislation';
                    Tooltip = 'Specifies the Luxembourg Legislation.';
                }

                field("RCS Enterprise Number"; Rec."RCS Enterprise Number")
                {
                    ApplicationArea = All;
                    Caption = 'RCS Enterprise Number';
                    Tooltip = 'Specifies the RCS Enterprise Number.';
                }

                field("eCDF - Prefix"; Rec."eCDF - Prefix")
                {
                    ApplicationArea = All;
                    Caption = 'eCDF - Prefix';
                    Tooltip = 'Specifies the eCDF - Prefix.';
                    // Width = 6; // --> Not working in this context : Page with Type : Card
                }

                field("Diplo. VAT Bus. Posting Origin"; Rec."Diplo. VAT Bus. Posting Origin")
                {
                    ApplicationArea = All;
                    Caption = 'Diplo. VAT Bus. Posting Origin';
                    Tooltip = 'Specifies the Diplo. VAT Bus. Posting Origin.';
                }

                field("Diplo. VAT Bus. Posting Exo"; Rec."Diplo. VAT Bus. Posting Exo")
                {
                    ApplicationArea = All;
                    Caption = 'Diplo. VAT Bus. Posting Exo';
                    Tooltip = 'Specifies the Diplo. VAT Bus. Posting Exo.';
                }

                field("Diplo. Threshold Amount"; Rec."Diplo. Threshold Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Diplo. Threshold Amount';
                    Tooltip = 'Specifies the Diplo. Threshold Amount.';
                }

                field("Declaration Intrastat Type"; Rec."Declaration Intrastat Type")
                {
                    ApplicationArea = All;
                    Caption = 'Declaration Intrastat Type';
                    Tooltip = 'Specifies the Declaration Intrastat Type.';
                }

                field("TaxationSystem"; Rec."TaxationSystem")
                {
                    ApplicationArea = All;
                    Caption = 'TaxationSystem';
                    Tooltip = 'Specifies the TaxationSystem.';
                }

                field("eCDF - XSD File"; Rec."eCDF - XSD File")
                {
                    ApplicationArea = All;
                    Caption = 'eCDF - XSD File';
                    Tooltip = 'Specifies the eCDF - XSD File.';
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    var
                        FileMgt: Codeunit "File Management";
                        FilePath: Text[250];
                    begin
                        rec."eCDF - XSD File" := FileMgt.UploadFile('Select eCDF - XSD File', FilePath);
                    end;
                }

                field("eCDF - XML Version"; Rec."eCDF - XML Version")
                {
                    ApplicationArea = All;
                    Caption = 'eCDF - XML Version';
                    Tooltip = 'Specifies the eCDF - XML Version.';
                }

            }

            group(Agent)
            {
                Caption = 'Agent';
                field("AMatrnb"; Rec."AMatrnb")
                {
                    ApplicationArea = All;
                    Caption = 'AMatrnb';
                    Tooltip = 'Specifies the AMatrnb.';
                }

                field("AVATNbr"; Rec."AVATNbr")
                {
                    ApplicationArea = All;
                    Caption = 'AVATNbr';
                    Tooltip = 'Specifies the AVATNbr.';
                }

                field("ARCSnbr"; Rec."ARCSnbr")
                {
                    ApplicationArea = All;
                    //Caption = 'ARCSnbr';
                    Tooltip = 'Specifies the ARCSnbr.';
                }


            }

            group(Declarant)
            {
                Caption = 'Declarant';
                field("DMatrnb"; Rec."DMatrnb")
                {
                    ApplicationArea = All;
                    Caption = 'DMatrnb';
                    Tooltip = 'Specifies the DMatrnb.';
                }

                field("DRCSnbr"; Rec."DRCSnbr")
                {
                    ApplicationArea = All;
                    Caption = 'DRCSnbr';
                    Tooltip = 'Specifies the DRCSnbr.';
                }

                field("DVATNbr"; Rec."DVATNbr")
                {
                    ApplicationArea = All;
                    Caption = 'DVATNbr';
                    Tooltip = 'Specifies the DVATNbr.';
                }

            }


        }
    }

    var
        XSDeCDFFile: Text[250];
}