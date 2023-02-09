/// <summary>
/// Table Luxembourg VAT Rules (ID 50901).
/// </summary>
table 50901 "Luxembourg VAT Rules"
{
    Caption = 'Luxembourg VAT Rules';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Statement Template Name"; Code[10])
        {
            CaptionML = ENU = 'Statement Template Name';
            TableRelation = "VAT Statement Template";
            DataClassification = CustomerContent;
        }
        field(2; "Statement Name"; Code[10])
        {
            CaptionML = ENU = 'Statement Name';
            TableRelation = "VAT Statement Name" where("Statement Template Name" = field("Statement Template Name"));
            DataClassification = CustomerContent;
        }
        field(4; "Row No."; Code[10])
        {
            CaptionML = ENU = 'Row No.';
            DataClassification = CustomerContent;
        }
        field(5; "Rule Number"; Integer)
        {
            CaptionML = ENU = 'Rule Number';
            DataClassification = CustomerContent;
        }
        field(50; Description; Text[50])
        {
            CaptionML = ENU = 'Description';
            DataClassification = CustomerContent;
        }
        field(100; "Data Type"; Option)
        {
            CaptionML = ENU = 'Data Type';
            OptionMembers = Numeric,Integer,Boolean,Alphanumeric,Percent;
            OptionCaptionML = ENU = 'Numeric,Integer,Boolean,Alphanumeric,Percent',
                              FRB = 'Numérique,Entier,Choix,Alphanumérique,Pourcentage';
            DataClassification = CustomerContent;
        }
        field(200; "Rule Type"; Option)
        {
            CaptionML = ENU = 'Rule Type';
            OptionMembers = Mandatory,"Mandatory if",Equal,"Not equal",Interval,Length,Date,"Less Than","Better Than","No Rule","Equal if Positive","Equal if Positive or 0";
            OptionCaptionML = ENU = 'Mandatory,Mandatory if,Equal,Not equal,Interval,Length,Date,Less Than,Better Than,No Rule,Equal if Positive,Equal if Positive or 0',
                              FRB = 'Obligatoire,Obligatoire si,Egal,Différent,Interval,Longueur,Date,Inférieur à,Supérieur à,Pas de règle,Egal si positif,Egal si positif ou 0';
            DataClassification = CustomerContent;
        }
        field(300; Control; Text[250])
        {
            CaptionML = ENU = 'Control';
            DataClassification = CustomerContent;
        }
        field(400; "Min. Value"; Decimal)
        {
            CaptionML = ENU = 'Min. Value';
            DataClassification = CustomerContent;
        }
        field(500; "Max. Value"; Decimal)
        {
            CaptionML = ENU = 'Max. Value';
            DataClassification = CustomerContent;
        }
        field(551; Day1; Code[10])
        {
            CaptionML = ENU = 'Day1';
            DataClassification = CustomerContent;
        }
        field(552; Month1; Code[10])
        {
            CaptionML = ENU = 'Month1';
            DataClassification = CustomerContent;
        }
        field(553; Sign; Option)
        {
            CaptionML = ENU = 'Sign';
            OptionMembers = ,S,I;
            OptionCaptionML = ENU = ' ,>=,<=',
                              FRB = ' ,>=,<=';
            DataClassification = CustomerContent;
        }
        field(554; Day2; Code[10])
        {
            CaptionML = ENU = 'Day2';
            DataClassification = CustomerContent;
        }
        field(555; Month2; Code[10])
        {
            CaptionML = ENU = 'Month2';
            DataClassification = CustomerContent;
        }
        field(600; "Start Date Validity"; Date)
        {
            CaptionML = ENU = 'Start Date Validity';
            DataClassification = CustomerContent;
        }
        field(601; "End Date Validity"; Date)
        {
            CaptionML = ENU = 'End Date Validity';
            DataClassification = CustomerContent;
        }
        field(602; Test; Text[250])
        {
            CaptionML = ENU = 'Test';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Statement Template Name")
        {
            Clustered = true;
        }
    }
}
