# bip39-cities-wordlist

A [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) compliant
wordlist consisting of 2,048 cities or city-like localities from around the world.

## Mnemonic sentences

Example mnemonic sentences generated using this list:

    aurora madrid cixi laurel wailuku sceaux pernik xian havirov siena cuenca vicenza
    riohacha gandia mashdad pitesti baglan miami ballarat aley poltava cabudare tumut nancy
    rockford barysaw young trenton ennis bodalla askoy qingdao honolulu balti tainan lund
    ogre yamba cucuta halmstad lorne regina dangriga dewsbury azua tehuacan ruse faenza
    coslada limoges crotone shoreham puebla pucallpa ourense fuzhou aden sedgley sacaba blyth

## Characteristics

The words in the list conform to the following characteristics, some (but not all) of
which are based on the "ideal wordlist" characteristics from the BIP39 spec, as well as
the
[BIP39 Wordlists (Special Considerations)](https://github.com/bitcoin/bips/blob/master/bip-0039/bip-0039-wordlists.md)
doc (note - the below characteristics are roughly in order from highest to lowest
priority):

- The list is sorted to allow more efficient lookup of the cities
- Only cities or city-like localities that exist and that are populated on planet Earth
  in the present day (no long-abandoned cities, no mythical cities, no fictional cities)
- Only plain English characters (for city names that are natively written using a
  non-English-like script, use the most officially recommended English-like
  transliteration)
- Each city is between 4 and 12 characters in length (no city whose commonly recognised
  name is shorter or longer than that)
- The first four letters unambiguously identify each city (no two cities whose first
  four letters are identical)
- No uppercase (each uppercase character is replaced with the corresponding a-z
  character)
- No accents or special characters (each such character is replaced with the
  corresponding a-z character)
- No spaces, hyphens, apostrophes, periods, commas, nor other punctuation marks (no city
  whose commonly recognised name includes any such character)
- No city name that is offensive in the English language
- Only one variety of spelling per city (with that variety being the one most officially
  recommended when using English-like characters)
- Prefer cities with a larger population
- Prefer cities that are the national capital
- Prefer cities that are the capital of some sub-national division
- Prefer cities that are not a smaller part of the metropolitan area / urban area of
  some larger city
- Prefer cities that have some claim to fame
- Prefer cities whose name is natively written using English script
- Prefer cities whose name is natively written using an English-like script
- Endeavour to represent all countries and other populated territories of the world

## Why?

First and foremost, it's more fun than plain dictionary words! Also:

- Proper nouns might be more appropriate than dictionary words in certain applications
- Geographical names might make sense in certain applications
- A mix of words from multiple languages might make sense in certain applications
