table 50902 "Luxembourg VAT Data"
{
    Caption = 'Luxembourg VAT Data';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Statement Template Name"; Code[10])
        {
            Caption = 'Statement Template Name';
            TableRelation = "VAT Statement Template";
            DataClassification = CustomerContent;
        }
        field(2; "Statement Name"; Code[10])
        {
            Caption = 'Statement Name';
            TableRelation = "VAT Statement Name" where("Statement Template Name" = field("Statement Template Name"));
            DataClassification = CustomerContent;
        }
        field(4; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(5; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(6; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Account Totaling","VAT Entry Totaling","Row Totaling",Description;
            OptionCaption = 'Account Totaling,VAT Entry Totaling,Row Totaling,Description';
            DataClassification = CustomerContent;
        }
        field(7; "Version"; Integer)
        {
            Caption = 'Version';
            DataClassification = CustomerContent;
        }
        field(8; "Gen. Posting Type"; Option)
        {
            Caption = 'Gen. Posting Type';
            OptionMembers = ,Purchase,Sale,Settlement;
            OptionCaption = ' ,Purchase,Sale,Settlement';
            DataClassification = CustomerContent;
        }
        field(10; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(11; "Row Totaling"; Text[80])
        {
            Caption = 'Row Totaling';
            DataClassification = CustomerContent;
        }
        field(12; "Amount Type"; Option)
        {
            Caption = 'Amount Type';
            OptionMembers = ,Amount,Base,"Unrealized Amount","Unrealized Base";
            OptionCaption = ' ,Amount,Base,Unrealized Amount,Unrealized Base';
            DataClassification = CustomerContent;
        }
        field(13; "Calculate with"; Option)
        {
            Caption = 'Calculate with';
            OptionMembers = Sign,"Opposite Sign";
            OptionCaption = 'Sign,Opposite Sign';
            DataClassification = CustomerContent;
        }
        field(15; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            DataClassification = CustomerContent;
        }
        field(21; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            DataClassification = CustomerContent;
        }
        field(22; "VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'VAT Prod. Posting Group';
            DataClassification = CustomerContent;
        }
        field(23; "Account Totaling"; Text[30])
        {
            Caption = 'Account Totaling';
            DataClassification = CustomerContent;
        }
        field(50; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(60; Comment; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }
        field(100; "Calculated Value"; Decimal)
        {
            Caption = 'Calculated Value';
            DataClassification = CustomerContent;
        }
        field(101; "Correction Amount"; Decimal)
        {
            Caption = 'Correction Amount';
            DataClassification = CustomerContent;
        }
        field(102; "Final Value"; Text[250])
        {
            Caption = 'Final Value';
            DataClassification = CustomerContent;
        }
        field(200; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = B,NOK,OK,Sent;
            OptionCaption = ' ,Error,Validated,Sent';
            DataClassification = CustomerContent;
        }
        field(201; "Last Error Message"; Text[250])
        {
            Caption = 'Last Error Message';
            DataClassification = CustomerContent;
        }
        field(202; "Status Header"; Option)
        {
            Caption = 'Status Header';
            OptionMembers = Working,Error,Validated;
            OptionCaption = 'Working,Error,Validated';
            FieldClass = FlowField;
            CalcFormula = Min("Luxembourg VAT Data".Status
                          WHERE("Statement Template Name" = FIELD("Statement Template Name"),
                                    "Statement Name" = FIELD("Statement Name"),
                                    "Starting Date" = FIELD("Starting Date"),
                                    "Ending Date" = FIELD("Ending Date"),
                                    Version = FIELD(Version)));
        }
        field(300; Sender; Code[50])
        {
            Caption = 'Sender';
            DataClassification = CustomerContent;
        }
        field(310; "Time Stamp Send"; DateTime)
        {
            Caption = 'Time Stamp Send';
            DataClassification = CustomerContent;
        }
        field(320; Filename; Text[50])
        {
            Caption = 'Filename';
            DataClassification = CustomerContent;
        }
        field(400; "Data Type"; Option)
        {
            Caption = 'Data Type';
            OptionMembers = ,N,I,B,A,P;
            OptionCaption = ' ,Numeric,Integer,Boolean,Alphanumeric,Percent';
            DataClassification = CustomerContent;
        }
        field(500; "Declaration Type"; Option)
        {
            Caption = 'Declaration Type';
            OptionMembers = VAT,INTRAG,INTRAS,INTRAT;
            OptionCaption = 'VAT,Intra. Goods,Intra. Services,EU 3-Party Trade';
            DataClassification = CustomerContent;
        }
        field(501; "Declaration Sub Type"; Option)
        {
            Caption = 'Declaration Sub Type';
            OptionMembers = ,VAT_OperationalExpenditures;
            OptionCaption = ' ,Operational Expenditures';
            DataClassification = CustomerContent;
        }
        field(700; "IntraComm Country/Region Code"; Code[10])
        {
            Caption = 'IntraComm Country/Region Code';
            DataClassification = CustomerContent;
        }
        field(701; "IntraComm VAT Registration No."; Text[50])
        {
            Caption = 'IntraComm VAT Registration No.';
            DataClassification = CustomerContent;
        }
        field(702; "IntraComm Customer No."; Code[20])
        {
            Caption = 'IntraComm Customer No.';
            DataClassification = CustomerContent;
        }
        field(50902; "XML Tag"; Text[30])
        {
            Caption = 'XML Tag';
            DataClassification = CustomerContent;
        }
        field(50903; "Correction Year"; Integer)
        {
            Caption = 'Correction Year';
            DataClassification = CustomerContent;
        }
        field(50904; "Correction Quarter"; Integer)
        {
            Caption = 'Correction Quarter';
            DataClassification = CustomerContent;
        }
        field(50905; "Correction Month"; Integer)
        {
            Caption = 'Correction Month';
            DataClassification = CustomerContent;
        }
        field(50906; "Correction Triang. Op."; Boolean)
        {
            Caption = 'Correction Triang. Op.';
            DataClassification = CustomerContent;
        }
        field(50910; "Balance Type"; Option)
        {
            Caption = 'Balance Type';
            OptionMembers = ,Debit,Credit;
            OptionCaption = ' ,Debit,Credit';
            DataClassification = CustomerContent;
        }
        field(50911; "Calc Total Deb. Balance Sheet"; Boolean)
        {
            Caption = 'Calc Total Deb. Balance Sheet';
            DataClassification = CustomerContent;
        }
        field(50912; "Calc Total Cre. Balance Sheet"; Boolean)
        {
            Caption = 'Calc Total Cre. Balance Sheet';
            DataClassification = CustomerContent;
        }

    }

    keys
    {
        key(PK_1; "Statement Template Name", "Statement Name", "Starting Date", "Ending Date", Version, "Line No.")
        {
            Clustered = true;
            SumIndexFields = "Calculated Value", "Correction Amount";
        }

        key(PK_2; "Row No.")
        {
            SumIndexFields = "Calculated Value", "Correction Amount";
        }

        key(PK_3; "XML Tag", "Row No.")
        {

        }

        key(PK_4; "XML Tag")
        {

        }
    }
}
