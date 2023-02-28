/// <summary>
/// Report Create XML File (ID 50902).
/// </summary>
report 50902 "Create XML File"
{
    ApplicationArea = All;
    Caption = 'Create XML File';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(eCDFData; "eCDF Data")
        {

            DataItemTableView = SORTING("Row No.") WHERE("Declaration Type" = FILTER(VAT));

            trigger OnPreDataItem()
            begin
                SavStatementTemplateName := '';
            end;

            trigger OnAfterGetRecord()
            var
                eCDFRules: Record "eCDF Data";
                VATStatementName: Record 257;
                Year: Integer;
                Period: Integer;
                TotalAmount2: Decimal;

            begin

                IF SavStatementTemplateName <> "Statement Name" THEN BEGIN

                    SavStatementTemplateName := "Statement Name";

                    XMLDOMMgt.AddElement(lParentXmlNode, 'Declaration', '', Xmlns01, lCurrXmlNode);

                    // Find the type document attribute link to Statement Name
                    VATStatementName.GET("Statement Template Name", "Statement Name");
                    DocumentTypeeCDF := VATStatementName."Statement eCDF Type";

                    XMLDOMMgt.AddAttribute(lCurrXmlNode, 'type', FORMAT(DocumentTypeeCDF));
                    XMLDOMMgt.AddAttribute(lCurrXmlNode, 'model', FORMAT(Model));
                    XMLDOMMgt.AddAttribute(lCurrXmlNode, 'language', FORMAT(Language));

                    lParentXmlNode := lCurrXmlNode;

                    Year := DATE2DMY("Starting Date", 3);
                    Period := DATE2DMY("Starting Date", 2);
                    XMLDOMMgt.AddElement(lParentXmlNode, 'Year', FORMAT(Year), Xmlns01, lCurrXmlNode);
                    XMLDOMMgt.AddElement(lParentXmlNode, 'Period', FORMAT(Period), Xmlns01, lCurrXmlNode);
                    XMLDOMMgt.AddElement(lParentXmlNode, 'FormData', '', Xmlns01, lCurrXmlNode);

                    lParentXmlNode := lCurrXmlNode;

                END;

                CASE "Data Type" OF

                    "Data Type"::Numeric:
                        BEGIN

                            IF DisplayData(TotalAmount, eCDFData) = TRUE THEN BEGIN

                                TotalAmount := "Calculated Value" + "Correction Amount";
                                XMLDOMMgt.AddElement(lParentXmlNode, 'NumericField', FORMAT(TotalAmount, 0, '<Sign><Integer>') + ',' + DELCHR(FORMAT(TotalAmount, 0, '<Decimals,3>'), '=', '.,'), Xmlns01, lCurrXmlNode);
                                XMLDOMMgt.AddAttribute(lCurrXmlNode, 'id', COPYSTR("Row No.", 2));

                            END;

                        END;

                    "Data Type"::Integer:
                        BEGIN

                            IF DisplayData(TotalAmount, eCDFData) = TRUE THEN BEGIN

                                TotalAmount := "Calculated Value" + "Correction Amount";
                                XMLDOMMgt.AddElement(lParentXmlNode, 'NumericField', FORMAT(TotalAmount, 0), Xmlns01, lCurrXmlNode);
                                XMLDOMMgt.AddAttribute(lCurrXmlNode, 'id', COPYSTR("Row No.", 2));

                            END;

                        END;

                    "Data Type"::Boolean:
                        BEGIN

                            XMLDOMMgt.AddElement(lParentXmlNode, 'Choice', "Final Value", Xmlns01, lCurrXmlNode);
                            XMLDOMMgt.AddAttribute(lCurrXmlNode, 'id', COPYSTR("Row No.", 2));

                        END;

                    "Data Type"::Alphanumeric:
                        BEGIN

                            IF DisplayData(TotalAmount, eCDFData) = TRUE THEN BEGIN
                                XMLDOMMgt.AddElement(lParentXmlNode, 'TextField', "Final Value", Xmlns01, lCurrXmlNode);
                                XMLDOMMgt.AddAttribute(lCurrXmlNode, 'id', COPYSTR("Row No.", 2));
                            END;

                        END;

                    "Data Type"::Percent:
                        BEGIN

                            IF DisplayData(TotalAmount, eCDFData) = TRUE THEN BEGIN
                                XMLDOMMgt.AddElement(lParentXmlNode, 'NumericField', "Final Value", Xmlns01, lCurrXmlNode);
                                XMLDOMMgt.AddAttribute(lCurrXmlNode, 'id', COPYSTR("Row No.", 2));
                            END;

                        END;
                END;

            end;

        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Export eCDF File")
                {
                    Caption = 'Create XML File';
                    field(Language; Language)
                    {
                        Caption = 'Language';
                        OptionCaption = 'FR,EN,DE';
                    }
                    field(Model; Model)
                    {
                        Caption = 'Model';
                    }
                    field(Version; Version)
                    {
                        Editable = false;
                    }
                    field(Interface; Interface)
                    {
                        Editable = false;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }

        trigger OnOpenPage()
        begin
            Version := '2.0';
            Interface := 'CEKL3';
        end;
    }

    trigger OnInitReport()
    begin
    end;

    trigger OnPreReport()
    begin

        CompanyInformation.GET('');
        CompanyInformation.TESTFIELD("eCDF - Prefix");
        CompanyInformation.TESTFIELD("RCS Enterprise Number");
        CompanyInformation.TESTFIELD(AMatrnb);
        CompanyInformation.TESTFIELD(ARCSnbr);
        CompanyInformation.TESTFIELD(AVATNbr);
        CompanyInformation.TESTFIELD(DMatrnb);
        CompanyInformation.TESTFIELD(DRCSnbr);
        CompanyInformation.TESTFIELD(DVATNbr);

        XMLDomMgt.AddDeclaration(XMLDomDoc, '1.0', 'UTF-8', '');
        XMLDomMgt.AddRootElementWithPrefix(XMLDomDoc, 'eCDFDeclarations', '', Xmlns01, lEnvelopeXmlNode);

        "File Reference" := CompanyInformation."eCDF - Prefix" + 'X' + FORMAT(TODAY, 0, '<year4><Month,2><day,2>') + 'T' + DELCHR(COPYSTR(FORMAT(TIME, 0, 2), 1, 9), '=', ':''.');
        XMLDOMMgt.AddElement(lEnvelopeXmlNode, 'FileReference', "File Reference", Xmlns01, lCurrXmlNode);
        XMLDOMMgt.AddElement(lEnvelopeXmlNode, 'eCDFFileVersion', Version, Xmlns01, lCurrXmlNode);
        XMLDOMMgt.AddElement(lEnvelopeXmlNode, 'Interface', Interface, Xmlns01, lCurrXmlNode);

        XMLDOMMgt.AddElement(lEnvelopeXmlNode, 'Agent', '', Xmlns01, lParentXmlNode);
        XMLDOMMgt.AddElement(lParentXmlNode, 'MatrNbr', FORMAT(CompanyInformation.AMatrnb), Xmlns01, lCurrXmlNode);
        XMLDOMMgt.AddElement(lParentXmlNode, 'RCSNbr', CompanyInformation.ARCSnbr, Xmlns01, lCurrXmlNode);
        XMLDOMMgt.AddElement(lParentXmlNode, 'VATNbr', FORMAT(DELSTR(CompanyInformation.AVATNbr, 1, 2)), Xmlns01, lCurrXmlNode);

        XMLDOMMgt.AddElement(lEnvelopeXmlNode, 'Declarations', '', Xmlns01, lParentXmlNode);
        XMLDOMMgt.AddElement(lParentXmlNode, 'Declarer', '', Xmlns01, lParentXmlNode);
        XMLDOMMgt.AddElement(lParentXmlNode, 'MatrNbr', FORMAT(CompanyInformation.DMatrnb), Xmlns01, lCurrXmlNode);
        XMLDOMMgt.AddElement(lParentXmlNode, 'RCSNbr', CompanyInformation.DRCSnbr, Xmlns01, lCurrXmlNode);
        XMLDOMMgt.AddElement(lParentXmlNode, 'VATNbr', FORMAT(DELSTR(CompanyInformation.DVATNbr, 1, 2)), Xmlns01, lCurrXmlNode);

    end;

    trigger OnPostReport()
    var
        //lTempBlob: Record TempBlob Temporary;
        leCdfData: Record "eCDF Data";
        lOutStr: OutStream;
        lInStr: InStream;
        lFilePath: Text;
        lFileName: Text;
    begin
        //Send file to browser
        //lTempBlob.Blob.CreateOutStream(lOutStr, TextEncoding::UTF8);
        XMLDomDoc.WriteTo(lOutStr);
        //lTempBlob.Blob.CreateInStream(lInStr, TextEncoding::UTF8);
        lFilePath := "File Reference" + '.xml';
        if (File.DownloadFromStream(lInStr, 'Export', '', '', lFilePath)) then begin

            lFileName := lFilePath.Substring(lFilePath.LastIndexOf('\') + 1);

            //Update VAT Statement lines.
            Clear(leCdfData);
            leCdfData.SETFILTER("Statement Template Name", eCDFData."Statement Template Name");
            leCdfData.SETFILTER("Statement Name", eCDFData.GETFILTER("Statement Name"));
            leCdfData.SETFILTER("Starting Date", eCDFData.GETFILTER("Starting Date"));
            leCdfData.SETFILTER("Ending Date", eCDFData.GETFILTER("Ending Date"));
            leCdfData.SETFILTER(Version, eCDFData.GETFILTER(Version));
            IF leCdfData.FINDSET THEN BEGIN
                REPEAT
                    leCdfData.VALIDATE(Status, leCdfData.Status::Sent);
                    leCdfData.VALIDATE(Sender, USERID);
                    leCdfData.VALIDATE("Time Stamp Send", CURRENTDATETIME);
                    leCdfData.VALIDATE(Filename, lFileName);
                //leCdfData.MODIFY(TRUE);
                UNTIL leCdfData.NEXT = 0;
            END;
        end;
    end;

    var
        GenLedSetup: Record "General Ledger Setup";
        CompanyInformation: Record "Company Information";
        eCDFDataAmount: Record "eCDF Data";
        eCDFRules: Record "eCDF Data";
        XMLDomMgt: Codeunit "eCDF XML DOM Management";
        XMLDomDoc: XmlDocument;
        XMLElementTmp01: XmlElement;
        lEnvelopeXmlNode: XmlNode;
        lParentXmlNode: XmlNode;
        lCurrXmlNode: XmlNode;
        SavStatementTemplateName: Code[20];
        Xmlns01: Label 'http://www.ctie.etat.lu/2011/ecdf', Locked = true;
        "File Reference": Text;
        Version: Text;
        Interface: Text;
        DocumentTypeeCDF: Option CA_BILAN,CA_BILANABR,CA_COMPP,CA_COMPPABR,CA_PLANCOMPTA,TVA_DECM,TVA_DECT,TVA_DECA,TVA_DECAS,TVA_LICM,TVA_LICT,TVA_PSIM,TVA_PSIT,AN_TABACAM;
        Language: Option FR,EN,DE;
        Model: Option "1","2";
        LineGoods: Integer;
        LineGoodsCorr: Integer;
        Lineservices: Integer;
        LineservicesCorr: Integer;
        LineEU3PartyTrade: Integer;
        TotalAmount: Decimal;
        TotalAmountCorr: Decimal;
        i: Integer;
        SAVTagForTable: Text;

    local procedure DisplayData(var TotalAmount: Decimal; PeCDFData: Record "eCDF Data") DispayAmount: Boolean
    var
        leCDFData: Record "eCDF Data";
        leCDFRules: Record "eCDF Rules";
    begin
        leCDFRules.RESET;
        leCDFRules.SETRANGE("Statement Template Name", PeCDFData."Statement Template Name");
        leCDFRules.SETRANGE("Statement Name", PeCDFData."Statement Name");
        leCDFRules.SETRANGE("Row No.", PeCDFData."Row No.");
        leCDFRules.SETRANGE("Rule Type", leCDFRules."Rule Type"::Mandatory);
        IF leCDFRules.FINDFIRST THEN
            EXIT(TRUE);

        IF STRPOS(PeCDFData."Row No.", '-') <> 0 THEN
            EXIT(FALSE);

        TotalAmount := PeCDFData."Calculated Value" + PeCDFData."Correction Amount";

        IF TotalAmount <> 0 THEN
            EXIT(TRUE);

        IF (PeCDFData."Data Type" = PeCDFData."Data Type"::Alphanumeric) THEN
            IF (PeCDFData."Final Value" = '') OR (PeCDFData."Final Value" = '0') THEN
                EXIT(FALSE);

        leCDFRules.RESET;
        leCDFRules.SETRANGE("Statement Template Name", PeCDFData."Statement Template Name");
        leCDFRules.SETRANGE("Statement Name", PeCDFData."Statement Name");
        leCDFRules.SETRANGE("Row No.", PeCDFData."Row No.");
        leCDFRules.SETRANGE("Rule Type", leCDFRules."Rule Type"::"Mandatory if");
        IF eCDFRules.FINDSET THEN BEGIN
            REPEAT
                leCDFData.SETRANGE("Statement Template Name", PeCDFData."Statement Template Name");
                leCDFData.SETRANGE("Statement Name", PeCDFData."Statement Name");
                leCDFData.SETRANGE("Starting Date", PeCDFData."Starting Date");
                leCDFData.SETRANGE("Ending Date", PeCDFData."Ending Date");
                leCDFData.SETRANGE(Version, PeCDFData.Version);
                leCDFData.SETFILTER("Row No.", leCDFRules.Control);
                IF leCDFData.FINDSET THEN
                    REPEAT
                        IF leCDFData."Calculated Value" + leCDFData."Correction Amount" <> 0 THEN
                            EXIT(TRUE);
                        IF (leCDFData."Final Value" <> '') AND (leCDFData."Final Value" <> '0') THEN
                            EXIT(TRUE);
                    UNTIL leCDFData.NEXT = 0;

            UNTIL leCDFRules.NEXT = 0;
        END;

        EXIT(FALSE);
    end;
}
