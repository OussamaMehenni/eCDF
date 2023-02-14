#pragma warning disable DOC0101
tableextension 50900 "Luxembourg Setup" extends "Company Information"
#pragma warning restore DOC0101
{
    Caption = 'Company Information_Ext';

    fields
    {
        field(50900; "Luxembourg Legislation"; Boolean)
        {
            CaptionML = ENU = 'Luxembourg Legislation',
                        FRB = 'Législation Luxembourgeoise';
            DataClassification = CustomerContent;
        }
        field(50901; "RCS Enterprise Number"; Code[50])
        {
            CaptionML = ENU = 'RCS Company Number',
                        FRB = 'N° RCS Société';
            DataClassification = CustomerContent;
        }
        field(50902; AMatrnb; Code[20])
        {
            CaptionML = ENU = 'Agent Register No.',
                        FRB = 'N° Matricule Agent';
            DataClassification = CustomerContent;
        }
        field(50903; ARCSnbr; Code[10])
        {
            CaptionML = ENU = 'RCS Agent No.',
                        FRB = 'N° RCS Agent';
            DataClassification = CustomerContent;
        }
        field(50904; AVATNbr; Code[30])
        {
            CaptionML = ENU = 'Agent VAT No.',
                        FRB = 'N° TVA Agent';
            DataClassification = CustomerContent;
        }
        field(50905; DMatrnb; Code[20])
        {
            CaptionML = ENU = 'Declarant Register No.',
                        FRB = 'N° Matricule Déclarant';
            DataClassification = CustomerContent;
        }
        field(50906; DRCSnbr; Code[10])
        {
            CaptionML = ENU = 'Declarant RCS No.',
                        FRB = 'N° RCS déclaran';
            DataClassification = CustomerContent;
        }
        field(50907; DVATNbr; Code[30])
        {
            CaptionML = ENU = 'Declarant VAT No.',
                        FRB = 'N° TVA déclarant';
            DataClassification = CustomerContent;
        }
        field(50908; "eCDF - Prefix"; Code[6])
        {
            CaptionML = ENU = 'eCDF - Prefix',
                        FRB = 'Préfixe - eCDF';
            Width = 6;
            DataClassification = CustomerContent;
        }
        field(50909; "Diplo. VAT Bus. Posting Origin"; Code[20])
        {
            CaptionML = ENU = 'Diplomat : Origin VAT Bus. Posting Group',
                        FRB = 'Diplomate : Groupe compta. marché TVA d''origine';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(50910; "Diplo. VAT Bus. Posting Exo"; Code[20])
        {
            CaptionML = ENU = 'Diplomat : VAT Bus. Posting Group exoneration',
                        FRB = 'Diplomate : Groupe compta. marché TVA exonération';
            DataClassification = CustomerContent;
            TableRelation = "VAT Business Posting Group";
        }
        field(50911; "Diplo. Threshold Amount"; Decimal)
        {
            CaptionML = ENU = 'Threshold Amount( Diplomat)',
                        FRB = 'Montant seuil (Diplomate)';
            DataClassification = CustomerContent;
        }

        field(50912; "Declaration Intrastat Type"; Option)
        {
            CaptionML = ENU = 'Declaration Intrastat Type',
                        FRB = 'Type de declaration Intrastat';
            OptionMembers = Simplified,Detailed;
            OptionCaptionML = ENU = 'Simplified,Detailed',
                              FRB = 'Simplifiée, Détaillée';
            DataClassification = CustomerContent;
        }

        field(50913; "TaxationSystem"; Option)
        {
            CaptionML = ENU = 'Taxation System',
                        FRB = 'Régime d''imposition';
            OptionMembers = Sales,Receipts;
            OptionCaptionML = ENU = 'Sales,Receipts',
                              FRB = 'Ventes,Recettes';
            DataClassification = CustomerContent;

        }

        field(50914; "eCDF - XSD File"; Text[250])
        {
            CaptionML = ENU = 'eCDF - XSD File',
                        FRB = 'Fichier XSD - eCDF';
            DataClassification = CustomerContent;
        }
        field(50915; "eCDF - XML Version"; Option)
        {
            CaptionML = ENU = 'eCDF - XML Version',
                        FRB = 'Version XML - eCDF';
            OptionCaption = 'XML 1.1,XML 2.0';
            OptionMembers = "XML 1.1","XML 2.0";
            DataClassification = CustomerContent;
        }
    }
}