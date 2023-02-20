/// <summary>
/// Table Luxembourg VAT Rules (ID 50901).
/// </summary>
table 50900 "eCDF Rules"
{
    Caption = 'eCDF Rules';
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
        field(4; "Row No."; Code[10])
        {
            Caption = 'Row No.';
            DataClassification = CustomerContent;
        }
        field(5; "Rule Number"; Integer)
        {
            Caption = 'Rule Number';
            DataClassification = CustomerContent;
        }
        field(50; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(100; "Data Type"; Option)
        {
            Caption = 'Data Type';
            OptionMembers = Numeric,Integer,Boolean,Alphanumeric,Percent;
            OptionCaption = 'Numeric,Integer,Boolean,Alphanumeric,Percent';
            DataClassification = CustomerContent;
        }
        field(200; "Rule Type"; Option)
        {
            Caption = 'Rule Type';
            OptionMembers = Mandatory,"Mandatory if",Equal,"Not equal",Interval,Length,Date,"Less Than","Better Than","No Rule","Equal if Positive","Equal if Positive or 0";
            OptionCaption = 'Mandatory,Mandatory if,Equal,Not equal,Interval,Length,Date,Less Than,Better Than,No Rule,Equal if Positive,Equal if Positive or 0';

            DataClassification = CustomerContent;
        }
        field(300; Control; Text[250])
        {
            Caption = 'Control';
            DataClassification = CustomerContent;
        }
        field(400; "Min. Value"; Decimal)
        {
            Caption = 'Min. Value';
            DataClassification = CustomerContent;
        }
        field(500; "Max. Value"; Decimal)
        {
            Caption = 'Max. Value';
            DataClassification = CustomerContent;
        }
        field(551; Day1; Code[10])
        {
            Caption = 'Day1';
            DataClassification = CustomerContent;
        }
        field(552; Month1; Code[10])
        {
            Caption = 'Month1';
            DataClassification = CustomerContent;
        }
        field(553; Sign; Option)
        {
            Caption = 'Sign';
            OptionMembers = ,S,I;
            OptionCaption = ' ,>=,<=';
            DataClassification = CustomerContent;
        }
        field(554; Day2; Code[10])
        {
            Caption = 'Day2';
            DataClassification = CustomerContent;
        }
        field(555; Month2; Code[10])
        {
            Caption = 'Month2';
            DataClassification = CustomerContent;
        }
        field(600; "Start Date Validity"; Date)
        {
            Caption = 'Start Date Validity';
            DataClassification = CustomerContent;
        }
        field(601; "End Date Validity"; Date)
        {
            Caption = 'End Date Validity';
            DataClassification = CustomerContent;
        }
        field(602; Test; Text[250])
        {
            Caption = 'Test';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Statement Template Name", "Statement Name", "Row No.", "Rule Number")
        {
            Clustered = true;

        }
    }
}
