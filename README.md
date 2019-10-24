# MPs activity

## Getting the data plan

### Trying to replicate original article

Originally I started off thinking to replicate the analysis done in [this article](http://www.maartenlambrechts.com/2016/10/03/how-i-built-a-scraper-to-measure-activity-of-mps.html). [Maarten Lambrechts](<http://www.maartenlambrechts.com/](https://multimedia.tijd.be/vlaamsparlement/)>) looked at the number of initiatives and questions by parliamentarians in the Flemish Parliament. Based on this he divided politicians in several categories like busy bee, chatterbox, ...

### But API is hard

However, when trying to replicate I hit some stumbling blocks. First of all I was pleased to see an [accompanying article](http://www.maartenlambrechts.com/2016/10/03/how-i-built-a-scraper-to-measure-activity-of-mps.html) exists explaining the process of making the article. This way I learned the Flemish parliament has its [own API](http://ws.vlpar.be/e/opendata/api) in the spirit of open data. Unfortunately using this API turned out to be harder than expected.

#### link MP - initiatives

My first idea was to use the same process as Lambrechts did but then instead of to scrape to use the API:

1. get all the MPs
2. get their details
3. extract info needed

The first 2 steps are easy (use `/vv/op-datum` and `/vv/{persoonId}` endpoints). Unfortunately the info returned is mostly just in a general sense. Most of it isn't too interesting for analysis (ereteken, deelstaatsenator, ...) or is interesting but difficult to parse (previous professions, ...). However, the following could be interesting.

General absences:

```
"aanwezigheden-huidige-legislatuur": {
        "commissie-aanw": [],
        "plenaire-aanw": {
            "aanwezig": 1,
            "afwezig": 1
        }
    }
```

We get no extra info about how or when these absences occur but we can use it to get the general picture (or double check data obtained in another way).

Other mandates:

```
"mandaat-andere": [
        {
            "mandaatgroepnaam": "Lokale mandaten",
            "parlmandaat": []
        },
        {
            "mandaatgroepnaam": "Federale mandaten",
            "parlmandaat": []
        }
    ]
```

Could be interesting to see if policitians why have other mandates at the same time (e.g. locally) are more absent.

Day of birth (age), gender (devil), party, education, ... are also simple data structures and can be easily interpreted.

#### detour using commissions

So if there's no straight link between the MP and an initiative maybe we can get there used a detour. So we could try to get all the commission reports using `/comm/{commId}/verslagen`. This returns the initiatives but does not encode who started the initiative. Sometimes the one who started the initiative is mentioned in the title but not always. We just know who made the report and who spoke on the subject.

```
"parl-initiatief": {
                "contacttype": [
                    {
                        "beschrijving": "Spreker",
                        "contact": []
                    },
                    {
                        "beschrijving": "Verslaggever",
                        "contact": []
                    }
                ],
                "titel": "Voorstel van resolutie van de heren Wouter Vanbesien en Björn Rzoska betreffende de organisatie van een hoorzitting met het middenveld over zijn visie op het beleid voor de komende zittingsperiode en over de gevraagde besparingsinspanningen.  Verslag namens de Commissie voor Algemeen Beleid, Financiën en Begroting uitgebracht door de heer Bart Tommelein"
        },
```

So in this example we can see the resolution was made by Wouter Vanbesien and Björn Rzoska but to parse this info would take quite some regex magic (and the result would never be optimal).

#### reports themselves

The last thing I tried was to look at the reports themselves using the `/comm/{commId}/verslagen` endpoint. In the end I chose to pursue the path of going after the meeting notes (instead of MPs, commissions and reports) directly. Because while exploring the API I noticed another stumbling block.

#### summary

Maarten Lambrechts in the end chose to just scrape the site of the parliament instead of using the API directly. However, I wanted to focus less on data collection and more on analysis in this article. Turning my mind to scraping would have meant doing a lot of (necessary) dirty plumbing which I frankly didn't feel like.

### And the concept is more ambiguous than it seems

Another stumbling block turned out to be the concepts of questions, interpellations, interventions, themselves... Parliamentary work is [not straightforward](https://www.vlaamsparlement.be/over-het-vlaams-parlement/begrippenlijst). It feels like aggregating all this work into a single variable of "number of questions and initiatives" does not do justice to the subject. So I'm at a crossroads here: either I can embrace the full complexity of the topic or I can find another angle. If I go for the complexity route I have to take all the different kinds of parliamentary work (motions, oral questions, interpellations, resolutions, debates, written questions, ...) into account widely expanding the scope of this article.

### And the API is poorly documented

However, although there's a lot of info in the API, there's little documentation about what concepts mean. To understand the resources I was dealing with I used the site of the parliament and its [glossary](https://www.vlaamsparlement.be/over-het-vlaams-parlement/begrippenlijst).

### So change of scope

The aim of posts like this is not to write a thesis, it's to focus on a limited subject and do something interesting with it. So I chose to go for another angle. While going through the API I noticed the agenda items returned by the `/verg/volledig/zoek` endpoint (which shows all the meetings in a certain time range or for a certain commission or plenary) not only give info about the topics and who did what but also about absences.

Most of the work is not done in the plenary session (where all the members of parliament are present) but in the commitees beforehand. So if you're not present for the commitee, you're not there the moment the real work is done. I chose to pick this angle because it's very binary (either you're there or you're not). In addition, other variables can be factored in like the party of the member of parliament, what commission it is, season, profession...

As regards to how much data is used. There's no hard reason to limit yourself. However, for the scope of this post focusing on the last legislature (2014-2019)seemed sufficiently.

So in a way the topic was driven by the data. Interestingly enough I didn't find any existing article from this angle (googled for absences flemish parliament). The article at the top was exactly the article I tried to replicate but that's clearly another angle.

## Getting the data implementation

Single:

- legislature (`/leg/alle`)
  - commission (`/comm/legislatuur`)
    - meeting notes (`/verg/volledig/zoek`)
      - presence: `items[i].vergadering.aanwezigheid[j].aanwezigheid-status`
      - first name: `items[i].vergadering.aanwezigheid[j].persoon.voornaam`
      - last name: `items[i].vergadering.aanwezigheid[j].persoon.naam`
      - mp id: `items[i].vergadering.aanwezigheid[j].persoon.id`
      - party id: `items[i].vergadering.aanwezigheid[j].persoon.fractie.id`
      - party name: `items[i].vergadering.aanwezigheid[j].persoon.fractie.naam`

Make sure to specify a month and year when looking for the meeting notes or the server can't handle it anymore (500).

Each index (i, j) will need a loop.

What you want to obtain is a csv with each row being a unique combinations of MP and meeting:

```
person_id | meeting_id
A         | X
B         | X
A         | Y
B         | Y
...
```

Having fields like personId, name, party, ...

## How does the Flemish parliament work?

[Tasks](https://www.vlaamsparlement.be/over-het-vlaams-parlement/hoe-werkt-het-vlaams-parlement/wat-zijn-de-hoofdtaken-van-het-vlaams) parliament:

- creates decrees
- controls the government
- approves the budget

Divisions:

- plenary
- commitee

[Plenary](https://www.vlaamsparlement.be/over-het-vlaams-parlement/hoe-werkt-het-vlaams-parlement/hoe-werkt-de-plenaire-vergadering).

De plenaire vergadering is de voltallige vergadering van alle 124 Vlaamse volksvertegenwoordigers

The plenary is the gathering of all members of parliament.

- discuss ontwerp van decreet/voorstel van decreet (prepared in commission)
- control government
  - actuele vragen
  - interpellaties
  - actualiteitsdebat
  - themadebat
  - resolutie
  - onderzoekscommissie

[Commitee](https://www.vlaamsparlement.be/over-het-vlaams-parlement/hoe-werkt-het-vlaams-parlement/hoe-werken-de-commissies).

Commitee is a group of members of parliaments specialized in a certain subject. Preparatory work for the plenary.

Parlementiary tasks divided in:

- initiatives
- questions
- interventions

## API Flemish parliament

## Visualization

Using ggplot2 just as the author of the article (but he used d3 in the online version).

## Summary original article

Add median line so divide in quadrants.

Faceting by party.

Link to election results.

Conclusions:

- fraction leaders ask lots
- NVA poor
- keep in mind how long it costs to make a proposal/question
- only for current term
- combination with other mandates
