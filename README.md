# JTrie
J language implementation of a trie data structure using multidimension arrays.
This follows the simple matrix version of a trie described in the paper:
 J. Aoe, K. Morimoto and T. Sato, ‘An efficient implementation of trie structures’, Software—Practice and Experience, 22, 695–721 (1992).
https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=f2ad2a67218e458a979afafb311d1d7867f3f624

The use of a trie simplifies dictionary type lookups on strings and provides O(n) time complexity. This is helpful in building 
AI transformer architecture that need word-piece tokenization. 

In the J. Aoe et al description of the simple multidimensional implementation the index origin for the matrix implementing the trie is index 1.
Since J's index origin is 0, row 0 is the failure state. All enteries in row 0 will be 0. Column 0 will hold the integer value of a string token.
So if your final state transition (call it state 'n') is a recognition state then the cell (n,0) will hold the integer value of the token.

## Usage
### creation/initialization
init_trie '<your_alphabet_string>'
### insertion
In the current implementation the trie provides for conversion of a recognized string to integer conversion.
Insertion therefore needs a string and an integer to insert into the trie. 

'snow' strval_ins 5
### lookup/retrieval
naive look up takes advantage that once you transition to the failure state (state 0) you will always stay there (there is no transition out). 
Therefore you just process the whole string character by character and if the final state is 0 ,it is a string token unknown to the trie. This
method allows the use of the J verb '\\' to be the basis of the look up. 

naive_tok '<your_string>'

naive_tok will return a non-zero integer representation of the string if found or 0 if not found. naive_tok ratchets through the trie by presenting every
letter in the string to the trie.

Short ciruit look up uses the Fold operation in J ('F:.'). This will stop processing once the first failure transition is made. The fold is encapsulated in
the routine ftok that has the same usage profile as naive_tok:

ftok '<your_string>'

