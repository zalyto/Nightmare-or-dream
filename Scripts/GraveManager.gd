extends Node

# La liste complète des données
var available_tombes := [
	["Guillaume de Montreval", "Il n'a pas regardé derrière lui", "† 13/08/47"],
	["Aélis de Rouvray", "Son silence fut éternel", "† 15/01/12"],
	["Hugues le Noir", "Il entra sans prier", "† 01/01/98"],
	["Jehan d'Aubecourt", "Il crut échapper à son sort", "† 24/02/74"],
	["Isabeau de Vienne", "La mort la trouva au crépuscule", "† 05/03/41"],
	["Raoul de Brisemur", "Il suivit le mauvais chemin", "† 10/02/16"],
	["Marguerite de Clairbois", "Elle ne revint jamais", "† 20/02/99"],
	["Thibaut de Ferrecourt", "Son courage ne suffit pas", "† 01/11/83"],
	["Ysabel de Mortemer", "Les cloches sonnèrent trop tard", "† 23/03/27"],
	["Odon le Roux", "Il n'écouta pas les avertissements", "† 12/02/09"],
	["Perrin de Lormes", "Son dernier pas fut ici", "† 05/02/61"],
	["Alienor de Châtillon", "La nuit l'emporta", "† 15/03/38"],
	["Gautier de Valombre", "Il n'aurait pas dû entrer", "† 03/02/24"],
	["Béatrice de Montfaucon", "La terre réclama son dû", "† 14/03/06"],
	["Renaud de Boisvert", "Il n'y eut aucun témoin", "† 10/11/72"],
	["Clémence de Gaga", "Toujours à rattraper le temps perdu", "† 08/05/85"],
	["Armand de Sire", "Il a troqué ses épées contre des tombes", "† 17/06/02"],
	["Félicie de Merlin", "Potion ratée, destin scellé", "† 02/08/10"],
	["Benoît de Jenny", "A trop vendu de secrets", "† 23/03/21"],
	["Hector de Lenny", "Trop de moutons et pas assez de prudence", "† 12/06/28"],
	["Isoline de Alphonse", "S'est perdue dans ses propres souvenirs", "† 19/03/32"],
	["Armand le Tavernier", "A goûté sa propre bière expérimentale", "† 07/06/44"],
	["Séraphin le Musicien", "Une note trop longue l'a suivi", "† 30/09/53"],
	["Hortense la Bibliothécaire", "A été ensevelie sous les livres", "† 11/11/59"],
	["Edouard le Voyageur", "S'est perdu dans son propre village", "† 15/01/68"],
	["Balthazar le Mage", "Trop de magie et pas assez de prudence", "† 06/08/76"],
	["Céleste de Montauban", "La lune l'a trouvée avant l'aube", "† 25/12/80"],
	["Gaspard de Rivière", "Tomber dans l'eau fut son dernier pas", "† 09/04/85"],
	["Ysolde la Fouine", "A fouillé un peu trop loin", "† 21/10/90"],
	["Théodore le Marchand", "Ses caisses ont roulé sur lui", "† 12/05/95"],
	["Madeleine des Champs", "A cueilli des fleurs mortelles par erreur", "† 08/07/98"],
	["Octave le Sage", "S'est assoupi sur la tombe de son meilleur ami", "† 03/03/00"],
	["Bérenger de Lormont", "Trop curieux pour sa propre survie", "† 14/08/03"],
	["Ameline la Sorcière", "Potion trop sucrée, destin trop amer", "† 19/05/07"],
	["Clotaire le Chauve", "A glissé sur la dernière échelle", "† 01/06/10"],
	["Éléonore la Vaillante", "A combattu les moutons jusqu'à la fin", "† 22/02/12"],
	["Régis le Poète", "Ses rimes l'ont suivi au tombeau", "† 10/09/15"],
	["Héloïse de la Vallée", "A confondu herbes et sortilèges", "† 05/11/20"],
	["Aymard le Braconnier", "Le piège l'a pris avant le lapin", "† 17/06/24"],
	["Solange la Pâtissière", "A goûté un peu trop de gâteaux magiques", "† 28/08/27"],
	["Maurice le Rieur", "Ria jusqu'à l'épuisement", "† 30/01/30"],
	["Violette de Sombreval", "A oublié où elle avait enterré ses secrets", "† 14/07/33"],
	["Gédéon le Marin", "A dérivé jusqu'à la légende", "† 19/04/36"],
	["Philippe de Rochefort", "La dernière carte était piégée", "† 12/12/39"],
	["Camille la Bouquine", "Ses livres l'ont engloutie", "† 21/03/41"],
	["Arnault de Brume", "A suivi un fantôme en oubliant le sol", "† 05/09/44"]
]


func _ready():
	# On mélange la liste une seule fois au début du jeu
	available_tombes.shuffle()
var nombre = 0
func get_next_grave_data():
	nombre += 1
	print(nombre)
	if nombre == 34:
		return ["George-Augustin", "Une tombe oubliée...", "† 25/12/51"]
		
	if available_tombes.size() > 0:
		# pop_front() retire le premier élément et le renvoie
		return available_tombes.pop_front()
	else:
		# Si on n'a plus de textes originaux, on renvoie un message par défaut
		return ["Inconnu", "Une tombe oubliée...", "† ????"]
