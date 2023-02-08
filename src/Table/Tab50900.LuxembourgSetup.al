/// <summary>
/// Table Luxembourg Setup (ID 50900).
/// </summary>
table 50900 "Luxembourg Setup"
{
    Caption = 'Luxembourg Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            CaptionML = ENU = 'Primary Key',
                        FRB = 'Clé Primaire';
            DataClassification = CustomerContent;
        }
        field(2; "Luxembourg Legislation"; Boolean)
        {
            CaptionML = ENU = 'Luxembourg Legislation',
                        FRB = 'Législation Luxembourgeoise';
            DataClassification = CustomerContent;
        }
        field(100; "RCS Enterprise Number"; Code[50])
        {
            CaptionML = ENU = 'RCS Company Number',
                        FRB = 'N° RCS Société';
            DataClassification = CustomerContent;
        }
        field(101; AMatrnb; Code[20])
        {
            CaptionML = ENU = 'Agent Register No.',
                        FRB = 'N° Matricule Agent';
            DataClassification = CustomerContent;
        }
        field(102; ARCSnbr; Code[10])
        {
            CaptionML = ENU = 'RCS Agent No.',
                        FRB = 'N° RCS Agent';
            DataClassification = CustomerContent;
        }
        field(103; AVATNbr; Code[30])
        {
            CaptionML = ENU = 'Agent VAT No.',
                        FRB = 'N° TVA Agent';
            DataClassification = CustomerContent;
        }
        field(104; DMatrnb; Code[20])
        {
            CaptionML = ENU = 'Declarant Register No.',
                        FRB = 'N° Matricule Déclarant';
            DataClassification = CustomerContent;
        }
        field(105; DRCSnbr; Code[10])
        {
            CaptionML = ENU = 'Declarant RCS No.',
                        FRB = 'N° RCS déclaran';
            DataClassification = CustomerContent;
        }
        field(106; DVATNbr; Code[30])
        {
            CaptionML = ENU = 'Declarant VAT No.',
                        FRB = 'N° TVA déclarant';
            DataClassification = CustomerContent;
        }
        field(107; "eCDF - Prefix"; Code[6])
        {
            CaptionML = ENU = 'eCDF - Prefix',
                        FRB = 'Préfixe - eCDF';
            DataClassification = CustomerContent;
        }
        field(900; "Diplo. VAT Bus. Posting Origin"; Code[20])
        {
            CaptionML = ENU = 'Diplomat : Origin VAT Bus. Posting Group',
                        FRB = 'Diplomate : Groupe compta. marché TVA d''origine';
            DataClassification = CustomerContent;
        }
        field(901; "Diplo. VAT Bus. Posting Exo"; Code[20])
        {
            CaptionML = ENU = 'Diplomat : VAT Bus. Posting Group exoneration',
                        FRB = 'Diplomate : Groupe compta. marché TVA exonération';
            DataClassification = CustomerContent;
        }
        field(902; "Diplo. Threshold Amount"; Decimal)
        {
            CaptionML = ENU = 'Threshold Amount( Diplomat)',
                        FRB = 'Montant seuil (Diplomate)';
            DataClassification = CustomerContent;
        }

        field(903; "Declaration Intrastat Type"; Option)
        {
            CaptionML = ENU = 'Declaration Intrastat Type',
                        FRB = 'Type de declaration Intrastat';
            OptionMembers = Simplified,Detailed;
            OptionCaptionML = ENU = 'Simplified,Detailed',
                              FRB = 'Simplifiée, Détaillée';
            DataClassification = CustomerContent;
        }

        field(904; "TaxationSystem"; Option)
        {
            CaptionML = ENU = 'Taxation System',
                        FRB = 'Régime d''imposition';
            OptionMembers = Sales,Receipts;
            OptionCaptionML = ENU = 'Sales,Receipts',
                              FRB = 'Ventes,Recettes';
            DataClassification = CustomerContent;

        }

        field(1000; "eCDF - XSD File"; Text[250])
        {
            CaptionML = ENU = 'eCDF - XSD File',
                        FRB = 'Fichier XSD - eCDF';
            DataClassification = CustomerContent;
        }
        field(1001; "eCDF - XML Version"; Option)
        {
            CaptionML = ENU = 'eCDF - XML Version',
                        FRB = 'Version XML - eCDF';
            OptionCaption = 'XML 1.1,XML 2.0';
            OptionMembers = "XML 1.1","XML 2.0";
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}
