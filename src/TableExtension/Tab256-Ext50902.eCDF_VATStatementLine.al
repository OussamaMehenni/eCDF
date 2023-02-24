
/// <summary>
/// TableExtension VAT Statement Line_Ext (ID 50902) extends Record VAT Statement Line.
/// </summary>
tableextension 50902 "VAT Statement Line_Ext" extends "VAT Statement Line"
{
    Caption = 'VAT Statement Line';

    fields
    {
        field(50900; "VAT Lux. Bus. Posting Group"; Code[20])
        {
            Caption = 'Luxembourg VAT Business Posting Group';
            TableRelation = "VAT Business Posting Group";
            ValidateTableRelation = false;
        }
        field(50901; "VAT Lux. Prod. Posting Group"; Code[20])
        {
            Caption = 'Luxembourg VAT Product Posting Group';
            TableRelation = "VAT Product Posting Group";
            ValidateTableRelation = false;
        }
    }
}