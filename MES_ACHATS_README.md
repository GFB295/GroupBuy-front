# 🛍️ Section "Mes Achats" - Application d'Achat Groupé

## 📱 Vue d'ensemble

Cette section offre une expérience mobile moderne et élégante pour gérer et suivre les commandes des utilisateurs. Elle comprend trois états principaux :

### 🎨 État 1 : Aucun achat effectué
- **Design** : Écran vide avec icône de sac gris au centre
- **Message** : "Aucune commande" + "Vous n'avez pas encore de commandes"
- **Action** : Bouton "Découvrir des offres" (vert/turquoise)
- **Navigation** : Redirection vers la page des offres

### 📦 État 2 : Liste de commandes
- **Design** : Cartes modernes avec ombres douces
- **Informations** : Nom du produit, date, statut, prix
- **Action** : Bouton "Suivre la commande" sur chaque carte
- **Statuts** : En attente, En préparation, En cours de livraison, Livrée

### 🗺️ État 3 : Tracking / Suivi de commande
- **Carte** : Google Maps intégrée avec marqueurs
- **Marqueurs** : Position du livreur + adresse de livraison
- **Route** : Ligne tracée entre les deux positions
- **ETA** : Estimation d'arrivée dans un encart élégant
- **Navigation** : Bouton retour pour revenir à la liste

## 🎨 Design System

### Palette de couleurs
- **Primaire** : `#0EA5E9` (Bleu turquoise)
- **Accent** : `#10B981` (Vert)
- **Texte principal** : `#1E293B` (Gris foncé)
- **Texte secondaire** : `#64748B` (Gris moyen)
- **Arrière-plan** : `#F8FAFC` (Gris très clair)
- **Blanc** : `#FFFFFF`

### Typographie
- **Police** : Google Fonts Poppins
- **Hiérarchie** : 
  - Titres : 20-24px, FontWeight.w600
  - Corps : 14-16px, FontWeight.normal
  - Captions : 11-12px, FontWeight.w600

### Composants
- **Cartes** : BorderRadius 16-20px, ombres douces
- **Boutons** : BorderRadius 12-16px, padding généreux
- **Icônes** : 16-24px, couleurs cohérentes

## 🛠️ Configuration technique

### Dépendances ajoutées
```yaml
dependencies:
  google_maps_flutter: ^2.5.3
  geolocator: ^10.1.0
```

### Permissions Android
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### Configuration Google Maps
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_API_GOOGLE_MAPS" />
```

## 📁 Structure des fichiers

```
lib/src/
├── screens/
│   └── my_purchases_screen.dart          # Écran principal "Mes Achats"
├── providers/
│   ├── order_provider.dart               # Gestion des commandes
│   └── tracking_provider.dart            # Gestion du tracking
└── models/
    └── order.dart                        # Modèle de données
```

## 🚀 Utilisation

### Navigation
```dart
// Accéder à la page "Mes Achats"
Navigator.pushNamed(context, '/my-purchases');
```

### États de test
1. **État vide** : Supprimer toutes les commandes du provider
2. **Liste** : Utiliser les données de démonstration
3. **Tracking** : Cliquer sur "Suivre la commande"

### Données de démonstration
```dart
// Commandes de test incluses
- Sac African TotBag (15,000 FCFA) - En cours de livraison
- AirPods Max + Clavier (340,000 FCFA) - En préparation  
- Chaussure Adidas (75,000 FCFA) - Livrée
```

## 🔧 Configuration Google Maps

### 1. Obtenir une clé API
1. Aller sur [Google Cloud Console](https://console.cloud.google.com/)
2. Créer un projet ou sélectionner un existant
3. Activer l'API Maps SDK for Android
4. Créer des identifiants (clé API)

### 2. Configurer la clé
```xml
<!-- Dans android/app/src/main/AndroidManifest.xml -->
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="VOTRE_CLE_API_ICI" />
```

### 3. Restrictions (recommandé)
- Limiter la clé API à votre package Android
- Restreindre l'utilisation aux APIs Maps uniquement

## 🎯 Fonctionnalités clés

### Responsive Design
- Adaptation automatique aux différentes tailles d'écran
- Espacement cohérent et hiérarchie visuelle claire
- Optimisé pour mobile (portrait et paysage)

### Expérience utilisateur
- **Pull-to-refresh** : Rafraîchir la liste des commandes
- **Animations fluides** : Transitions entre les écrans
- **Feedback visuel** : États de chargement et d'erreur
- **Accessibilité** : Contrastes appropriés et tailles de texte

### Performance
- **Lazy loading** : Chargement des images à la demande
- **Caching** : Mise en cache des données de tracking
- **Optimisation** : Réduction des appels API

## 🔄 États de développement

### Phase 1 ✅ (Implémentée)
- [x] Design des trois états principaux
- [x] Intégration Google Maps
- [x] Données de démonstration
- [x] Navigation fluide

### Phase 2 🚧 (À implémenter)
- [ ] Intégration avec l'API backend
- [ ] Mise à jour en temps réel du tracking
- [ ] Notifications push pour les mises à jour
- [ ] Historique détaillé des commandes

### Phase 3 📋 (Futur)
- [ ] Mode hors ligne
- [ ] Partage de position
- [ ] Chat avec le livreur
- [ ] Évaluation post-livraison

## 🐛 Dépannage

### Problèmes courants

**Google Maps ne s'affiche pas**
- Vérifier la clé API dans AndroidManifest.xml
- S'assurer que l'API Maps SDK est activée
- Vérifier les permissions de localisation

**Erreur de compilation**
```bash
flutter clean
flutter pub get
flutter run
```

**Problèmes de performance**
- Vérifier la taille des images
- Optimiser les appels API
- Utiliser le lazy loading

## 📞 Support

Pour toute question ou problème :
1. Vérifier la configuration Google Maps
2. Consulter les logs de débogage
3. Tester avec les données de démonstration
4. Vérifier les permissions Android

---

**Note** : Cette implémentation est optimisée pour une expérience mobile moderne avec un design épuré et une navigation intuitive. 