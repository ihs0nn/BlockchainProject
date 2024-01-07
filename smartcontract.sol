// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

contract VerifierIntegriteDonnees {

    // Adresse de l'administrateur du contrat
    address admin;

    // Constructeur du contrat qui initialise l'adresse de l'administrateur
    constructor() {
        admin = msg.sender;
    }

    // Tableau pour stocker et extraire les empreintes de hachage des fichiers associées à leurs URL
    mapping (string => bytes32) internal FileHash;

    // Fonction de hachage interne
    function hash(string memory content) internal pure returns(bytes32) {
        // Utilisation de la fonction de hachage keccak256 pour obtenir l'empreinte de hachage du contenu
        bytes32 contentHash = keccak256(bytes(content));
        return contentHash;
    }

    // Fonction pour mettre à jour l'empreinte de hachage d'un fichier
    function mettreAJourEmpreinteFichier(string memory _url, string memory _contenu) public {
        // Seul l'administrateur peut créer ou mettre à jour une empreinte de hachage de fichier
        require(msg.sender == admin, "Vous n'avez pas l'autorisation de mettre à jour les empreintes de hachage des fichiers");
        FileHash[_url] = hash(_contenu);
    }

    // Fonction pour vérifier l'intégrité du contenu d'un fichier
    function verifierIntegriteDonnees(string memory _url, string memory _nouveauContenu) public view returns(string memory) {
        string memory message;

        // Vérifier si l'URL est valide
        if (FileHash[_url] == bytes32(0)) {
            message = "Cette URL est invalide, vérifiez le fichier téléchargé et réessayez";
            return message;
        }

        // Récupérer l'empreinte de hachage actuelle et celle du nouveau contenu
        bytes32 empreinteCourante = FileHash[_url];
        bytes32 nouvelleEmpreinte = hash(_nouveauContenu);

        // Vérifier si le contenu a été modifié
        if (empreinteCourante == nouvelleEmpreinte) {
            message = "Le contenu n'a pas été modifié !";
            return message;
        } else {
            message = "Le contenu a été modifié !";
            return message;
        }
    }
}

