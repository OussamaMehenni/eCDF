/// <summary>
/// Page Luxembourg Setup Card (ID 50900).
/// </summary>
page 50900 "Luxembourg Setup Card"
{
    Caption = 'Luxembourg Setup Card';
    PageType = Card;
    SourceTable = "Luxembourg Setup";
    UsageCategory = Documents;
    ApplicationArea = All;

    layout
    {

        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            FRB = 'Général';
                field("Luxembourg Legislation"; Rec."Luxembourg Legislation")
                {
                    ApplicationArea = All;
                    //Caption = 'Luxembourg Legislation';
                    Tooltip = 'Specifies the Luxembourg Legislation.';
                }

                field("RCS Enterprise Number"; Rec."RCS Enterprise Number")
                {
                    ApplicationArea = All;
                    //Caption = 'RCS Enterprise Number';
                    Tooltip = 'Specifies the RCS Enterprise Number.';
                }

                field("eCDF - Prefix"; Rec."eCDF - Prefix")
                {
                    ApplicationArea = All;
                    //Caption = 'eCDF - Prefix';
                    Tooltip = 'Specifies the eCDF - Prefix.';
                }

                field("Diplo. VAT Bus. Posting Origin"; Rec."Diplo. VAT Bus. Posting Origin")
                {
                    ApplicationArea = All;
                    //Caption = 'Diplo. VAT Bus. Posting Origin';
                    Tooltip = 'Specifies the Diplo. VAT Bus. Posting Origin.';
                }

                field("Diplo. VAT Bus. Posting Exo"; Rec."Diplo. VAT Bus. Posting Exo")
                {
                    ApplicationArea = All;
                    //Caption = 'Diplo. VAT Bus. Posting Exo';
                    Tooltip = 'Specifies the Diplo. VAT Bus. Posting Exo.';
                }

                field("Diplo. Threshold Amount"; Rec."Diplo. Threshold Amount")
                {
                    ApplicationArea = All;
                    //Caption = 'Diplo. Threshold Amount';
                    Tooltip = 'Specifies the Diplo. Threshold Amount.';
                }

                field("Declaration Intrastat Type"; Rec."Declaration Intrastat Type")
                {
                    ApplicationArea = All;
                    //Caption = 'Declaration Intrastat Type';
                    Tooltip = 'Specifies the Declaration Intrastat Type.';
                }

                field("TaxationSystem"; Rec."TaxationSystem")
                {
                    ApplicationArea = All;
                    //Caption = 'TaxationSystem';
                    Tooltip = 'Specifies the TaxationSystem.';
                }

                field("eCDF - XSD File"; Rec."eCDF - XSD File")
                {
                    ApplicationArea = All;
                    //Caption = 'eCDF - XSD File';
                    Tooltip = 'Specifies the eCDF - XSD File.';
                    trigger OnAssistEdit()
                    var
                        EKLU01: Text[250];
                        FileManagement: Codeunit "File Management";
                    begin
                        EKLU01 := 'Nom du fichier ';
                        //"eCDF - XSD File" := FileManagement.UploadFile(EKLU01, '');
                    end;
                }

                field("eCDF - XML Version"; Rec."eCDF - XML Version")
                {
                    ApplicationArea = All;
                    //Caption = 'eCDF - XML Version';
                    Tooltip = 'Specifies the eCDF - XML Version.';
                }

            }

            group(Agent)
            {
                CaptionML = ENU = 'Agent',
                            FRB = 'Agent';
                field("AMatrnb"; Rec."AMatrnb")
                {
                    ApplicationArea = All;
                    //Caption = 'AMatrnb';
                    Tooltip = 'Specifies the AMatrnb.';
                }

                field("AVATNbr"; Rec."AVATNbr")
                {
                    ApplicationArea = All;
                    //Caption = 'AVATNbr';
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
                CaptionML = ENU = 'Declarant',
                            FRB = 'Déclarant';
                field("DMatrnb"; Rec."DMatrnb")
                {
                    ApplicationArea = All;
                    //Caption = 'DMatrnb';
                    Tooltip = 'Specifies the DMatrnb.';
                }

                field("DRCSnbr"; Rec."DRCSnbr")
                {
                    ApplicationArea = All;
                    //Caption = 'DRCSnbr';
                    Tooltip = 'Specifies the DRCSnbr.';
                }

                field("DVATNbr"; Rec."DVATNbr")
                {
                    ApplicationArea = All;
                    //Caption = 'DVATNbr';
                    Tooltip = 'Specifies the DVATNbr.';
                }
            }
        }
    }

    trigger OnOpenPage()
    VAR
        MyInt: Integer;
    begin

    end;

    trigger OnAfterGetRecord()
    var
    begin

    end;

}