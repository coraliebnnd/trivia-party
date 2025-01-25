import 'package:trivia_party/bloc/models/answer.dart';
import 'package:trivia_party/bloc/models/categories.dart';
import 'package:trivia_party/networking/question_loader.dart';

final Map<int, List<QuestionAnswerPair>> categoryCannedQuestionMap = {
  25: [
    QuestionAnswerPair("Who designed the Chupa Chups logo?", [
      Answer("Salvador Dali", true),
      Answer("Pablo Picasso", false),
      Answer("Andy Warhol", false),
      Answer("Vincent van Gogh", false),
    ]),
    QuestionAnswerPair("Who painted the epic mural Guernica?", [
      Answer("Pablo Picasso", true),
      Answer("Francisco Goya", false),
      Answer("Leonardo da Vinci", false),
      Answer("Henri Matisse", false),
    ]),
    QuestionAnswerPair(
        "Which artist's style was to use small different colored dots to create a picture?",
        [
          Answer("Georges Seurat", true),
          Answer("Paul Cozanne", false),
          Answer("Vincent Van Gogh", false),
          Answer("Henri Rousseau", false),
        ]),
    QuestionAnswerPair(
        "What nationality was the surrealist painter Salvador Dali?", [
      Answer("Spanish", true),
      Answer("Italian", false),
      Answer("French", false),
      Answer("Portuguese", false),
    ]),
    QuestionAnswerPair("Vincent van Gogh cut off one of his ears.", [
      Answer("True", true),
      Answer("False", false),
    ]),
    QuestionAnswerPair(
        "Which one of these paintings is not by Caspar David Friedrich?", [
      Answer("The Black Sea", true),
      Answer("The Sea of Ice", false),
      Answer("Wanderer above the Sea of Fog", false),
      Answer("The Monk by the Sea", false),
    ]),
    QuestionAnswerPair(
        "Pablo Picasso is one of the founding fathers of \"Cubism.\"", [
      Answer("True", true),
      Answer("False", false),
    ]),
    QuestionAnswerPair(
        "Venus of Willendorf is one of the earliest works of art, depicting the planets Mars and Venus embrace in the heavens at night.",
        [
          Answer("False", true),
          Answer("True", false),
        ]),
    QuestionAnswerPair(
        "Which of these are the name of a famous marker brand?", [
      Answer("Copic", true),
      Answer("Dopix", false),
      Answer("Cofix", false),
      Answer("Marx", false),
    ]),
    QuestionAnswerPair(
        "Which time signature is commonly known as 'Cut Time?''", [
      Answer("2/2", true),
      Answer("4/4", false),
      Answer("6/8", false),
      Answer("3/4", false),
    ]),
  ],
  10: [
    QuestionAnswerPair(
        "In The Lies of Locke Lamora, what title is Locke known by in the criminal world?",
        [
          Answer("The Thorn of Camorr", true),
          Answer("The Rose of the Marrows", false),
          Answer("The Thorn of Emberlain", false),
          Answer("The Thorn of the Marrows", false),
        ]),
    QuestionAnswerPair(
        "In Alice in Wonderland, what is the name of Alice's kitten?", [
      Answer("Dinah", true),
      Answer("Oscar", false),
      Answer("Heath", false),
      Answer("Smokey", false),
    ]),
    QuestionAnswerPair(
        "What is the make and model of the tour vehicles in \"Jurassic Park\" (1990)?",
        [
          Answer("1989 Toyota Land Cruiser", true),
          Answer("1989 Jeep Wrangler YJ Sahar", false),
          Answer("1989 Ford Explorer XLT", false),
          Answer("Mercedes M-Class", false),
        ]),
    QuestionAnswerPair(
        "Originally, the character Charlie from Charlie and the Chocolate Factory was going to be black.",
        [
          Answer("True", true),
          Answer("False", false),
        ]),
    QuestionAnswerPair(
        "The title of Adolf Hitler's autobiography \"Mein Kampf\" is what when translated to English?",
        [
          Answer("My Struggle", true),
          Answer("My Hatred", false),
          Answer("My Sadness", false),
          Answer("My Desire", false),
        ]),
    QuestionAnswerPair("What is the fourth book of the Old Testament?", [
      Answer("Numbers", true),
      Answer("Genesis", false),
      Answer("Exodus", false),
      Answer("Leviticus", false),
    ]),
    QuestionAnswerPair(
        "Which of the following is not a work authored by Fyodor Dostoevsky?", [
      Answer("Anna Karenina", true),
      Answer("Notes from the Underground", false),
      Answer("Crime and Punishment", false),
      Answer("The Brothers Karamazov", false),
    ]),
    QuestionAnswerPair(
        "What book series published by Jim Butcher follows a wizard in modern day Chicago?",
        [
          Answer("The Dresden Files", true),
          Answer("A Hat in Time", false),
          Answer("The Cinder Spires", false),
          Answer("My Life as a Teenage Wizard", false),
        ]),
    QuestionAnswerPair("In the \"The Hobbit\", who kills Smaug?", [
      Answer("Bard", true),
      Answer("Bilbo Baggins", false),
      Answer("Gandalf the Grey", false),
      Answer("Frodo", false),
    ]),
    QuestionAnswerPair("Who wrote the 1967 horror novel \"Rosemary's Baby\"?", [
      Answer("Ira Levin", true),
      Answer("Stephen King", false),
      Answer("Robert Bloch", false),
      Answer("Mary Shelley", false),
    ]),
  ],
  15: [
    QuestionAnswerPair("How many classes are there in Team Fortress 2?", [
      Answer("9", true),
      Answer("10", false),
      Answer("8", false),
      Answer("7", false),
    ]),
    QuestionAnswerPair(
        "In Left 4 Dead, what is the name of the Special Infected that is unplayable in Versus mode?",
        [
          Answer("The Witch", true),
          Answer("The Tank", false),
          Answer("The Smoker", false),
          Answer("The Spitter", false),
        ]),
    QuestionAnswerPair(
        "Which of the following is not a prosecutor in the \"Ace Attorney\" video game series?",
        [
          Answer("Jake Marshall", true),
          Answer("Godot", false),
          Answer("Miles Edgeworth", false),
          Answer("Jacques Portsman", false),
        ]),
    QuestionAnswerPair(
        "Mirror's Edge Catalyst takes place in the City of...?", [
      Answer("Glass", true),
      Answer("Mirrors", false),
      Answer("Purity", false),
      Answer("Diamonds", false),
    ]),
    QuestionAnswerPair("Which city hosted the CS:GO Dreamhack Open 2015?", [
      Answer("Cluj-Napoca", true),
      Answer("Cologne", false),
      Answer("Atlanta", false),
      Answer("London", false),
    ]),
    QuestionAnswerPair(
        "Which unlockable character in Super Smash Bros. For Wii U and 3DS does not have to be fought to be unlocked?",
        [
          Answer("Mii Fighters", true),
          Answer("Ness", false),
          Answer("R.O.B.", false),
          Answer("Mewtwo", false),
        ]),
    QuestionAnswerPair(
        "In Night in the Woods, which instrument did Casey play?", [
      Answer("Drums", true),
      Answer("Bass", false),
      Answer("Piano", false),
      Answer("Sax", false),
    ]),
    QuestionAnswerPair("When was Final Fantasy XV released?", [
      Answer("November 29th, 2016", true),
      Answer("October 25th, 2016", false),
      Answer("December 31th, 2016", false),
      Answer("November 30th, 2016", false),
    ]),
    QuestionAnswerPair(
        "In Monster Hunter Generations, which of the following monsters are a part of the \"Fated Four\"?",
        [
          Answer("Astalos", true),
          Answer("Gore Magala", false),
          Answer("Malfestio", false),
          Answer("Arzuros", false),
        ]),
    QuestionAnswerPair(
        "Which of these features was added in the 1994 game \"Heretic\" that the original \"DOOM\" could not add due to limitations?",
        [
          Answer("Looking up and down", true),
          Answer("Increased room sizes", false),
          Answer("Unlimited weapons", false),
          Answer("Highly-detailed textures", false),
        ]),
  ],
  11: [
    QuestionAnswerPair(
        "Joan Cusack starred in the 2009 disaster movie, \"2012\".", [
      Answer("False", true),
      Answer("True", false),
    ]),
    QuestionAnswerPair(
        "In the 1999 movie Fight Club, which of these is not a rule of the \"fight club\"?",
        [
          Answer("Always wear a shirt", true),
          Answer("You do not talk about FIGHT CLUB", false),
          Answer("Only two guys to a fight", false),
          Answer("Fights will go on as long as they have to", false),
        ]),
    QuestionAnswerPair(
        "Who provided a majority of the songs and lyrics for \"Spirit: Stallion of the Cimarron\"?",
        [
          Answer("Bryan Adams", true),
          Answer("Smash Mouth", false),
          Answer("Oasis", false),
          Answer("Air Supply", false),
        ]),
    QuestionAnswerPair(
        "What is the name of the dog that played Toto in the 1939 film \"The Wizard of Oz\"?",
        [
          Answer("Terry", true),
          Answer("Tommy", false),
          Answer("Teddy", false),
          Answer("Toto", false),
        ]),
    QuestionAnswerPair(
        "The movie \"Tron\" received an Oscar nomination for Best Visual Effects.",
        [
          Answer("False", true),
          Answer("True", false),
        ]),
    QuestionAnswerPair(
        "This movie contains the quote, \"I love the smell of napalm in the morning!\"",
        [
          Answer("Apocalypse Now", true),
          Answer("Platoon", false),
          Answer("The Deer Hunter", false),
          Answer("Full Metal Jacket", false),
        ]),
    QuestionAnswerPair(
        "Who voiced the character Draco in the 1996 movie 'DragonHeart'?", [
      Answer("Sean Connery", true),
      Answer("Dennis Quaid", false),
      Answer("Pete Postlethwaite", false),
      Answer("Brian Thompson", false),
    ]),
    QuestionAnswerPair(
        "Brendan Fraser starred in the following movies, except which one?", [
      Answer("Titanic", true),
      Answer("Monkeybone", false),
      Answer("Encino Man", false),
      Answer("Mrs. Winterbourne", false),
    ]),
    QuestionAnswerPair(
        "Which actor plays the role of the main antagonist in the 2011 movie \"Tower Heist?\"",
        [
          Answer("Alan Alda", true),
          Answer("Eddie Murphy", false),
          Answer("Alec Baldwin", false),
          Answer("Kevin Nealon", false),
        ]),
    QuestionAnswerPair(
        "What is the name of the first \"Star Wars\" film by release order?", [
      Answer("A New Hope", true),
      Answer("The Phantom Menace", false),
      Answer("The Force Awakens", false),
      Answer("Revenge of the Sith", false),
    ]),
  ],
  21: [
    QuestionAnswerPair("Which country is hosting the 2022 FIFA World Cup?", [
      Answer("Qatar", true),
      Answer("Uganda", false),
      Answer("Vietnam", false),
      Answer("Bolivia", false),
    ]),
    QuestionAnswerPair(
        "Which soccer team won the Copa America 2015 Championship ?", [
      Answer("Chile", true),
      Answer("Argentina", false),
      Answer("Brazil", false),
      Answer("Paraguay", false),
    ]),
    QuestionAnswerPair(
        "Which Formula One driver was nicknamed 'The Professor'?", [
      Answer("Alain Prost", true),
      Answer("Ayrton Senna", false),
      Answer("Niki Lauda", false),
      Answer("Emerson Fittipaldi", false),
    ]),
    QuestionAnswerPair("Who was the top scorer of the 2014 FIFA World Cup?", [
      Answer("James Rodriguez", true),
      Answer("Thomas Müller", false),
      Answer("Lionel Messi", false),
      Answer("Neymar", false),
    ]),
    QuestionAnswerPair("What is the highest belt you can get in Taekwondo?", [
      Answer("Black", true),
      Answer("White", false),
      Answer("Red", false),
      Answer("Green", false),
    ]),
    QuestionAnswerPair(
        "Who is Manchester United's top premier league goal scorer?", [
      Answer("Wayne Rooney", true),
      Answer("Sir Bobby Charlton", false),
      Answer("Ryan Giggs", false),
      Answer("David Beckham", false),
    ]),
    QuestionAnswerPair(
        "Which NBA player won Most Valuable Player for the 1999-2000 season?", [
      Answer("Shaquille O'Neal", true),
      Answer("Allen Iverson", false),
      Answer("Kobe Bryant", false),
      Answer("Paul Pierce", false),
    ]),
    QuestionAnswerPair(
        "In what sport does Fanny Chmelar compete for Germany?", [
      Answer("Skiing", true),
      Answer("Swimming", false),
      Answer("Showjumping", false),
      Answer("Gymnastics", false),
    ]),
    QuestionAnswerPair(
        "Which Formula 1 driver switched teams in the middle of the 2017 season?",
        [
          Answer("Carlos Sainz Jr.", true),
          Answer("Daniil Kvyat", false),
          Answer("Jolyon Palmer", false),
          Answer("Rio Haryanto", false),
        ]),
    QuestionAnswerPair(
        "Which of the following Grand Slam tennis tournaments occurs LAST?", [
      Answer("US Open", true),
      Answer("French Open", false),
      Answer("Wimbledon", false),
      Answer("Australian Open", false),
    ])
  ],
  12: [
    QuestionAnswerPair(
        "The song \"Twin Size Mattress\" was written by which band?", [
      Answer("The Front Bottoms", true),
      Answer("Twenty One Pilots", false),
      Answer("The Wonder Years", false),
      Answer("The Smith Street Band", false),
    ]),
    QuestionAnswerPair(
        "What musician made the song \"F**kin` Perfect\" in 2010?", [
      Answer("P!nk", true),
      Answer("Mitis", false),
      Answer("Adam lambert", false),
      Answer("Koven", false),
    ]),
    QuestionAnswerPair("What was Bon Iver's debut album released in 2007?", [
      Answer("For Emma, Forever Ago", true),
      Answer("Bon Iver, Bon Iver", false),
      Answer("22, A Million", false),
      Answer("Blood Bank EP", false),
    ]),
    QuestionAnswerPair(
        "What song on ScHoolboy Q's album Black Face LP featured Kanye West?", [
      Answer("THat Part", true),
      Answer("Neva CHange", false),
      Answer("Big Body", false),
      Answer("Blank Face", false),
    ]),
    QuestionAnswerPair(
        "Which American family band had a 1986 top 10 hit with the song 'Crush On You'?",
        [
          Answer("The Jets", true),
          Answer("DeBarge", false),
          Answer("The Jacksons", false),
          Answer("The Cover Girls", false),
        ]),
    QuestionAnswerPair(
        "Which of these songs by artist Eminem contain the lyric \"Nice to meet you. Hi, my name is... I forgot my name!\"?",
        [
          Answer("Rain Man", true),
          Answer("Without Me", false),
          Answer("Kim", false),
          Answer("Square Dance", false),
        ]),
    QuestionAnswerPair("What was David Bowie's real surname?", [
      Answer("Jones", true),
      Answer("Johnson", false),
      Answer("Edwards", false),
      Answer("Carter", false),
    ]),
    QuestionAnswerPair(
        "Liam Howlett founded which electronic music group in 1990?", [
      Answer("The Prodigy", true),
      Answer("The Chemical Brothers", false),
      Answer("The Crystal Method", false),
      Answer("Infected Mushroom", false),
    ]),
    QuestionAnswerPair("What was Raekwon the Chefs debut solo album?", [
      Answer("Only Built 4 Cuban Linx", true),
      Answer("Shaolin vs Wu-Tang", false),
      Answer("The Wild", false),
      Answer("The Lex Diamond Story", false),
    ]),
    QuestionAnswerPair(
        "How many copies have Metallica album \"Metallica\" (A.K.A The Black Album) sold worldwide (in Millions of Copies)?",
        [
          Answer("20.5", true),
          Answer("19.5", false),
          Answer("22.5", false),
          Answer("25.5", false),
        ]),
  ]
};
