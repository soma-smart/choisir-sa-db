---
# try also 'default' to start simple
theme: ../slidev-theme-soma
# some information about your slides (markdown enabled)
title: Comment choisir sa base de données
info: |
  ## Comment choisir sa base de données
  Besoins, performances & scalabilité
# apply UnoCSS classes to the current slide
class: text-center
# https://sli.dev/features/drawing
drawings:
  persist: false
# slide transition: https://sli.dev/guide/animations.html#slide-transitions
transition: fade
# enable MDC Syntax: https://sli.dev/features/mdc
mdc: true
---

<div class="flex items-center justify-center">
  <div class="flex flex-col items-end text-right">
    <h1 class="text-4xl font-extrabold text-gray-800 dark:text-white mb-2">Comment choisir sa base de données</h1>
    <h2 class="text-xl font-semibold text-gray-800 dark:text-gray-300">
      Besoins, performances & scalabilité
    </h2>
    <span class="text-lg font-bold text-gray-700 dark:text-gray-400 mt-4">
      Hugues GAILLARD - Novembre 2025
    </span>
  </div>
  <div>
      <Compass />
  </div>
</div>
<!-- <div @click="$slidev.nav.next" class="mt-12 py-1" hover:bg="white op-10">
  Press Space for next page <carbon:arrow-right />
</div> -->

<!--
The last comment block of each slide will be treated as slide notes. It will be visible and editable in Presenter Mode along with the slide. [Read more in the docs](https://sli.dev/guide/syntax.html#notes)
-->

---
layout: two-cols
layoutClass: gap-16
---

# Au sommaire

Dans cette Masterclass, nous allons explorer les différentes bases de données et leurs spécificités.

<Compass />

À la fin de cette heure, vous aurez une culture & une grille de lecture claire pour faire des choix éclairés et justifiés.

::right::

<Toc text-sm minDepth="1" maxDepth="2" />

---
layout: quote
---
# Law of the instrument

<div class="flex items-center justify-between gap-8 h-[400px]">
  <div class="flex-1 p-6 text-left flex flex-col justify-center">
    <blockquote class="italic text-gray-700 dark:text-gray-200 mb-4">
      <span class="text-2xl">
        “It is tempting, if the only tool you have is a hammer, to treat everything as if it were a nail.”
      </span>
    </blockquote>
    <div class="text-right text-lg text-gray-500 dark:text-gray-400">
      Abraham Maslow, 1966<br>
      <span class="text-base">Law of the instrument</span>
    </div>
  </div>
  <div class="flex-1 flex justify-center items-center">
    <img
      src="/abraham-maslow-jeune.jpg"
      alt="Abraham Maslow"
      class="rounded-lg object-cover shadow-lg dark:shadow-gray-900"
    />
  </div>
</div>


---

# La jungle des bases de données


<Databases />
<p v-click>
</p>
<p v-click>
</p>
<p v-click>
</p>
<p v-click>
</p>

<!--
You can have `style` tag in markdown to override the style for the current page.
Learn more: https://sli.dev/features/slide-scope-style
-->

<!--
Here is another comment.
-->
---
---
# La base de données parfaite ?

<div class="flex flex-col gap-1 items-start text-left text-lg">

<span v-mark.underline.blue v-click="1">- Pour le DBA :</span><span v-click="2"> facile à installer, évolutive, bien documentée...</span>

<span v-mark.underline.blue="3" v-click="3">- Pour les utilisateurs :</span><span v-click="4"> simple à requêter, fiable, rapide...</span>

<span v-mark.underline.blue="5" v-click="5">- Pour la sécurité :</span><span v-click="6"> certifiée, résiliente, chiffrée...</span>

<span v-mark.underline.blue="7" v-click="7">- Pour la direction :</span> <span v-click="8"> économique, supportée, pérenne...</span>

</div>

<div class="mt-8 text-xl font-bold text-center">
<span v-click="9">Est-ce que cette base de données existe ? </span>
<span v-mark.red="10" v-click="10">Non.</span>
</div>

<div class="mt-4 text-lg text-center">
<span v-click="11">Il faut nécessairement faire des </span><span v-mark.box.orange="12" v-click="12">compromis.</span><br>
<span v-click="13">Et pour choisir les bons compromis, il faut d'abord bien comprendre les </span><span v-mark.box.blue="14" v-click="14">besoins.</span>
</div>


---
layout: image-right
image: https://cover.sli.dev
---

# Code

Use code snippets and get the highlighting directly, and even types hover!

```ts [filename-example.ts] {all|4|6|6-7|9|all} twoslash
// TwoSlash enables TypeScript hover information
// and errors in markdown code blocks
// More at https://shiki.style/packages/twoslash
import { computed, ref } from "vue";

const count = ref(0);
const doubled = computed(() => count.value * 2);

doubled.value = 2;
```

<arrow v-click="[4, 5]" x1="350" y1="310" x2="195" y2="342" color="#953" width="2" arrowSize="1" />

<!-- This allow you to embed external code blocks -->

<<< @/snippets/external.ts#snippet

<!-- Footer -->

[Learn more](https://sli.dev/features/line-highlighting)

<!-- Inline style -->
<style>
.footnotes-sep {
  @apply mt-5 opacity-10;
}
.footnotes {
  @apply text-sm opacity-75;
}
.footnote-backref {
  display: none;
}
</style>

<!--
Notes can also sync with clicks

[click] This will be highlighted after the first click

[click] Highlighted with `count = ref(0)`

[click:3] Last click (skip two clicks)
-->

---

## level: 2

# Shiki Magic Move

Powered by [shiki-magic-move](https://shiki-magic-move.netlify.app/), Slidev supports animations across multiple code snippets.

Add multiple code blocks and wrap them with <code>````md magic-move</code> (four backticks) to enable the magic move. For example:

````md magic-move {lines: true}
```ts {*|2|*}
// step 1
const author = reactive({
  name: "John Doe",
  books: [
    "Vue 2 - Advanced Guide",
    "Vue 3 - Basic Guide",
    "Vue 4 - The Mystery",
  ],
});
```

```ts {*|1-2|3-4|3-4,8}
// step 2
export default {
  data() {
    return {
      author: {
        name: "John Doe",
        books: [
          "Vue 2 - Advanced Guide",
          "Vue 3 - Basic Guide",
          "Vue 4 - The Mystery",
        ],
      },
    };
  },
};
```

```ts
// step 3
export default {
  data: () => ({
    author: {
      name: "John Doe",
      books: [
        "Vue 2 - Advanced Guide",
        "Vue 3 - Basic Guide",
        "Vue 4 - The Mystery",
      ],
    },
  }),
};
```

Non-code blocks are ignored.

```vue
<!-- step 4 -->
<script setup>
const author = {
  name: "John Doe",
  books: [
    "Vue 2 - Advanced Guide",
    "Vue 3 - Basic Guide",
    "Vue 4 - The Mystery",
  ],
};
</script>
```
````

---

# Components

<div grid="~ cols-2 gap-4">
<div>

You can use Vue components directly inside your slides.

We have provided a few built-in components like `<Tweet/>` and `<Youtube/>` that you can use directly. And adding your custom components is also super easy.

```html
<Counter :count="10" />
```

<!-- ./components/Counter.vue -->
<Counter :count="10" m="t-4" />

Check out [the guides](https://sli.dev/builtin/components.html) for more.

</div>
<div>

```html
<Tweet id="1390115482657726468" />
```

<Tweet id="1390115482657726468" scale="0.65" />

</div>
</div>

<!--
Presenter note with **bold**, *italic*, and ~~striked~~ text.

Also, HTML elements are valid:
<div class="flex w-full">
  <span style="flex-grow: 1;">Left content</span>
  <span>Right content</span>
</div>
-->

---

# Themes

Slidev comes with powerful theming support. Themes can provide styles, layouts, components, or even configurations for tools. Switching between themes by just **one edit** in your frontmatter:

<div grid="~ cols-2 gap-2" m="t-2">

```yaml
---
theme: default
---
```

```yaml
---
theme: seriph
---
```

<img border="rounded" src="https://github.com/slidevjs/themes/blob/main/screenshots/theme-default/01.png?raw=true" alt="">

<img border="rounded" src="https://github.com/slidevjs/themes/blob/main/screenshots/theme-seriph/01.png?raw=true" alt="">

</div>

Read more about [How to use a theme](https://sli.dev/guide/theme-addon#use-theme) and
check out the [Awesome Themes Gallery](https://sli.dev/resources/theme-gallery).

---

# Clicks Animations

You can add `v-click` to elements to add a click animation.

<div v-click>

This shows up when you click the slide:

```html
<div v-click>This shows up when you click the slide.</div>
```

</div>

<br>

<v-click>

The <span v-mark.red="3"><code>v-mark</code> directive</span>
also allows you to add
<span v-mark.circle.orange="4">inline marks</span>
, powered by [Rough Notation](https://roughnotation.com/):

```html
<span v-mark.underline.orange>inline markers</span>
```

</v-click>

<div mt-20 v-click>

[Learn more](https://sli.dev/guide/animations#click-animation)

</div>

---

# Motions

Motion animations are powered by [@vueuse/motion](https://motion.vueuse.org/), triggered by `v-motion` directive.

```html
<div
  v-motion
  :initial="{ x: -80 }"
  :enter="{ x: 0 }"
  :click-3="{ x: 80 }"
  :leave="{ x: 1000 }"
>
  Slidev
</div>
```

<div class="w-60 relative">
  <div class="relative w-40 h-40">
    <img
      v-motion
      :initial="{ x: 800, y: -100, scale: 1.5, rotate: -50 }"
      :enter="final"
      class="absolute inset-0"
      src="https://sli.dev/logo-square.png"
      alt=""
    />
    <img
      v-motion
      :initial="{ y: 500, x: -100, scale: 2 }"
      :enter="final"
      class="absolute inset-0"
      src="https://sli.dev/logo-circle.png"
      alt=""
    />
    <img
      v-motion
      :initial="{ x: 600, y: 400, scale: 2, rotate: 100 }"
      :enter="final"
      class="absolute inset-0"
      src="https://sli.dev/logo-triangle.png"
      alt=""
    />
  </div>

  <div
    class="text-5xl absolute top-14 left-40 text-[#2B90B6] -z-1"
    v-motion
    :initial="{ x: -80, opacity: 0}"
    :enter="{ x: 0, opacity: 1, transition: { delay: 2000, duration: 1000 } }">
    Slidev
  </div>
</div>

<!-- vue script setup scripts can be directly used in markdown, and will only affects current page -->
<script setup lang="ts">
const final = {
  x: 0,
  y: 0,
  rotate: 0,
  scale: 1,
  transition: {
    type: 'spring',
    damping: 10,
    stiffness: 20,
    mass: 2
  }
}
</script>

<div
  v-motion
  :initial="{ x:35, y: 30, opacity: 0}"
  :enter="{ y: 0, opacity: 1, transition: { delay: 3500 } }">

[Learn more](https://sli.dev/guide/animations.html#motion)

</div>

---

# LaTeX

LaTeX is supported out-of-box. Powered by [KaTeX](https://katex.org/).

<div h-3 />

Inline $\sqrt{3x-1}+(1+x)^2$

Block

$$
{1|3|all}
\begin{aligned}
\nabla \cdot \vec{E} &= \frac{\rho}{\varepsilon_0} \\
\nabla \cdot \vec{B} &= 0 \\
\nabla \times \vec{E} &= -\frac{\partial\vec{B}}{\partial t} \\
\nabla \times \vec{B} &= \mu_0\vec{J} + \mu_0\varepsilon_0\frac{\partial\vec{E}}{\partial t}
\end{aligned}
$$

[Learn more](https://sli.dev/features/latex)

---

# Diagrams

You can create diagrams / graphs from textual descriptions, directly in your Markdown.

<div class="grid grid-cols-4 gap-5 pt-4 -mb-6">

```mermaid {scale: 0.5, alt: 'A simple sequence diagram'}
sequenceDiagram
    Alice->John: Hello John, how are you?
    Note over Alice,John: A typical interaction
```

```mermaid {theme: 'neutral', scale: 0.8}
graph TD
B[Text] --> C{Decision}
C -->|One| D[Result 1]
C -->|Two| E[Result 2]
```

```mermaid
mindmap
  root((mindmap))
    Origins
      Long history
      ::icon(fa fa-book)
      Popularisation
        British popular psychology author Tony Buzan
    Research
      On effectiveness<br/>and features
      On Automatic creation
        Uses
            Creative techniques
            Strategic planning
            Argument mapping
    Tools
      Pen and paper
      Mermaid
```

```plantuml {scale: 0.7}
@startuml

package "Some Group" {
  HTTP - [First Component]
  [Another Component]
}

node "Other Groups" {
  FTP - [Second Component]
  [First Component] --> FTP
}

cloud {
  [Example 1]
}

database "MySql" {
  folder "This is my folder" {
    [Folder 3]
  }
  frame "Foo" {
    [Frame 4]
  }
}

[Another Component] --> [Example 1]
[Example 1] --> [Folder 3]
[Folder 3] --> [Frame 4]

@enduml
```

</div>

Learn more: [Mermaid Diagrams](https://sli.dev/features/mermaid) and [PlantUML Diagrams](https://sli.dev/features/plantuml)

---

foo: bar
dragPos:
square: 691,32,167,\_,-16

---

dragPos:
square: 0,-40,0,0

---

dragPos:
square: 0,-40,0,0

---
dragPos:
  square: -187,0,0,0
---

# Draggable Elements

Double-click on the draggable elements to edit their positions.

<br>

###### Directive Usage

```md
<img v-drag="'square'" src="https://sli.dev/logo.png">
```

<br>

###### Component Usage

```md
<v-drag text-3xl>
  <div class="i-carbon:arrow-up" />
  Use the `v-drag` component to have a draggable container!
</v-drag>
```

<v-drag pos="607,251,126,_,-15">
  <div text-center text-3xl border border-main rounded>
    Double-click me!
  </div>
</v-drag>

<img v-drag="'square'" src="https://sli.dev/logo.png">

###### Draggable Arrow

```md
<v-drag-arrow two-way />
```

<v-drag-arrow pos="412,233,155,66" two-way op70 />

---

src: ./pages/imported-slides.md
hide: false

---


---

# Monaco Editor

Slidev provides built-in Monaco Editor support.

Add `{monaco}` to the code block to turn it into an editor:

```ts {monaco}
import { ref } from "vue";
import { emptyArray } from "./external";

const arr = ref(emptyArray(10));
```

Use `{monaco-run}` to create an editor that can execute the code directly in the slide:

```ts {monaco-run}
import { version } from "vue";
import { emptyArray, sayHello } from "./external";

sayHello();
console.log(`vue ${version}`);
console.log(
  emptyArray<number>(10).reduce(
    (fib) => [...fib, fib.at(-1)! + fib.at(-2)!],
    [1, 1]
  )
);
```

---

layout: center
class: text-center

---

# Plan

Partie 1 : Les Fondations : OLTP vs. OLAP, le clivage fondamental (10 minutes)
Slide 4 : Le premier filtre : Pour quoi faire ? Opérationnel vs. Analytique

Introduction du concept : la nature de la charge de travail (workload) est le critère N°1.

Slide 5 : L'OLTP (Online Transaction Processing)

Analogie : Le caissier de supermarché.

Objectif : Faire tourner l'application au quotidien.

Caractéristiques : Requêtes courtes et rapides, écritures fréquentes, forte concurrence, faible latence, données très normalisées.

Exemples de requêtes : INSERT INTO users..., UPDATE products SET stock = stock - 1...

Cas d'usage : Panier d'un site e-commerce, inscription utilisateur, transaction bancaire.

Slide 6 : L'OLAP (Online Analytical Processing)

Analogie : Le contrôleur de gestion qui analyse les ventes du trimestre.

Objectif : Aider à la prise de décision (Business Intelligence).

Caractéristiques : Requêtes longues et complexes, lectures massives, agrégations, données historiques dénormalisées (schéma en étoile).

Exemples de requêtes : SELECT SUM(sales), category FROM facts_sales GROUP BY category...

Cas d'usage : Dashboard de ventes, prévision de la demande, analyse de logs.

Slide 7 : Tableau récapitulatif OLTP vs. OLAP

Un tableau simple comparant les deux sur des axes clés : Type de requête, Volume par requête, Fréquence, Orientation (Ligne vs. Colonne), Objectif.

Partie 2 : Le Panorama : Les grandes familles de bases de données (15 minutes)
Slide 8 : Introduction aux familles

"Il n'y a pas de 'meilleure' base de données, seulement le meilleur outil pour un problème donné."

Slide 9 : 1. Le Relationnel (SQL)

Concept : Le standard historique. Schéma strict, tables, jointures, transactions ACID.

Idéal pour : Les données structurées avec des relations complexes et un besoin de forte cohérence.

Exemples : PostgreSQL, MySQL, SQL Server.

Slide 10 : 2. Le NoSQL : Un monde de possibilités

Introduction au mouvement NoSQL : flexibilité, scalabilité horizontale.

a) Document : (MongoDB)

Concept : Stocke des "documents" (JSON, BSON). Schéma flexible.

Idéal pour : Contenu web, catalogues produits, applications aux exigences évolutives.

b) Clé-Valeur : (Redis)

Concept : Le plus simple. Un dictionnaire géant. GET(key) -> value.

Idéal pour : Cache, gestion de sessions, files d'attente. Performance brute.

Slide 11 : Le NoSQL (suite)

c) Orienté Colonne : (Cassandra, Bigtable)

Concept : Stocke les données par colonne, pas par ligne. Très efficace pour les agrégations sur un sous-ensemble de colonnes. (Lien direct avec l'OLAP).

Idéal pour : Séries temporelles, IoT, analytique à grande échelle.

d) Graphe : (Neo4j)

Concept : Optimisé pour stocker et requêter les relations entre les données (nœuds et arêtes).

Idéal pour : Réseaux sociaux, détection de fraude, moteurs de recommandation.

Slide 12 : 3. Les nouvelles frontières

a) Vectoriel : (Pinecone, Weaviate, pg_vector)

Concept : Spécialisé dans le stockage et la recherche de vecteurs (embeddings). Le cerveau des IA modernes.

Idéal pour : Recherche sémantique, recherche par image, systèmes de recommandation basés sur l'IA.

b) Hybride / NewSQL : (CockroachDB, TiDB)

Concept : Le meilleur des deux mondes ? Interface SQL, transactions ACID, mais avec la scalabilité horizontale du NoSQL.

Idéal pour : Applications globales critiques nécessitant à la fois cohérence et scalabilité massive.

Partie 3 : La Boussole : Les 5 critères pour ne plus se tromper (10 minutes)
Slide 13 : Le framework "CAP-EV"

Une grille d'analyse simple pour guider le choix.

Slide 14 : C - Consistance (Modèle de données et garanties)

ACID vs. BASE. Avez-vous besoin d'une cohérence transactionnelle forte (banque) ou d'une cohérence à terme (like sur un post) ?

Quelle est la structure de vos données ? Fixe ou évolutive ?

Slide 15 : A - "Access Patterns" (Modèle de requêtage)

Comment allez-vous lire et écrire la donnée ? Requêtes simples par ID ? Jointures complexes ? Agrégations ? Traversée de graphe ? Recherche full-text ?

C'est le critère le plus souvent sous-estimé.

Slide 16 : P - Performance & Scalabilité

Besoins en latence et débit (reads/sec, writes/sec).

Scalabilité verticale ("scale-up" : une plus grosse machine) ou horizontale ("scale-out" : plus de machines) ?

Slide 17 : E - Ecosystème & Expertise

Le facteur humain : Quelles sont les compétences de votre équipe ?

Maturité de la technologie, support de la communauté, bibliothèques disponibles, outillage (monitoring, backup...).

Slide 18 : V - Volume & Vélocité

Quelle quantité de données aujourd'hui ? Et dans 5 ans ? (Go, To, Po...).

À quelle vitesse les données arrivent-elles ? (Batch vs. Streaming).

Partie 4 : Le Crash Test : 3 bases, 3 usages (15 minutes)
Slide 19 : Scénario 1 : Le cœur d'une application SaaS (OLTP)

Besoin : Gérer les utilisateurs, les abonnements, la facturation. Forte cohérence requise.

Benchmark : PostgreSQL

Pourquoi ?

Consistance : ACID est non-négociable.

Access Pattern : Requêtes relationnelles complexes (jointures entre clients, factures, plans).

Ecosystème : Le plus riche de tous les SGBD open source. Fiable, robuste, des extensions pour tout (PostGIS, pg_vector, TimescaleDB...). C'est le "couteau suisse" par défaut.

Slide 20 : Scénario 2 : Un dashboard analytique interactif (OLAP)

Besoin : Analyser des millions de logs de vente pour un dashboard interne. Vitesse d'analyse primordiale.

Benchmark : DuckDB vs. Snowflake

DuckDB :

Le "SQLite de l'analytique". Base de données en "in-process".

Force : Zéro administration, incroyablement rapide pour des analyses sur un seul nœud (PC, petit serveur). Parfait pour l'exploration de données en local, l'analytique embarquée.

Snowflake :

Le Data Warehouse Cloud natif.

Force : Séparation du stockage et du calcul, scalabilité quasi infinie, modèle de paiement à l'usage. Idéal pour les entrepôts de données d'entreprise, les équipes multiples.

Verdict : DuckDB pour le prototypage et l'analytique "embarquée". Snowflake pour la plateforme BI d'entreprise.

Slide 21 : Scénario 3 : Moteur de recherche sémantique pour une IA

Besoin : Permettre aux utilisateurs de rechercher des produits par des descriptions en langage naturel ("une robe rouge pour l'été").

Benchmark : PostgreSQL + pg_vector

Pourquoi ?

Access Pattern : C'est un cas d'usage de recherche vectorielle (ANN - Approximate Nearest Neighbor).

Le choix pragmatique : pg_vector est une extension qui transforme PostgreSQL en une base vectorielle "suffisamment bonne".

Avantages : Pas besoin de gérer une nouvelle infrastructure. On combine les données transactionnelles (prix, stock) et les vecteurs dans la même base. Idéal pour démarrer.

Alternative (mention) : Une base spécialisée (Pinecone, Weaviate) devient pertinente à très grande échelle, quand la recherche vectorielle est LE cœur du produit.

Conclusion (5 minutes)
Slide 22 : Synthèse des points clés

OLTP vs. OLAP : C'est toujours la première question à se poser.

Connaissez vos requêtes : L' "Access Pattern" dicte la famille de BDD.

Soyez pragmatique : Commencez simple. Un outil polyvalent comme PostgreSQL couvre 80% des besoins. N'ajoutez de la complexité (et une nouvelle BDD) que lorsque c'est absolument nécessaire et justifié.

Slide 23 : Le mot de la fin

"Ne choisissez pas une base de données sur un coup de tête ou pour suivre une mode. Analysez, testez, et choisissez l'outil qui résout votre problème, pas celui qui en crée de nouveaux."

Remerciements et lien vers les slides/ressources.

Slide 24 : Q&A

Une slide simple avec vos coordonnées (Twitter/LinkedIn/GitHub) pour les questions.

