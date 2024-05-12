NB. jtrie.ijs - trie implementation in J
NB. both full matrix and sparse matrix implementations in one file 
NB. and in an object oriented design. This was the easiest way
NB. of allowing multiple tries to be defined without having 
NB. to rename alphabets and keeping track of which alphabet goes 
NB. with which trie.

cocurrent 'jtrie'
NB. constants and a view function 
NB. taken from Roger Stokes Learning J chapter 30
NB. https://www.jsoftware.com/help/learning/30.htm
INTEGERZERO =: 3 - 3
INTEGERONE =: 3 - 2
view =: 0 & $.

NB. init_trie will initialized state variables and the empty trie
NB. x - 1 for sparse matrix; 0 for full matrix
NB. y - the alphabet to use with this trie
create=: 3 : 0
'sparse alphabet' =: y NB. '#ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'

NB. Since column 0 in the trie will hold a token for a recognition state
NB. put an unlikely to be used character at the front of the alphabet.
NB. for the purpose of recognizing single words a space would be guarenteed not
NB. to be used
alphabet =: ' ',alphabet

NB. make the trierow one larger than the number of characters in the alphabet
NB. this is because i. will give index 1 larger than number of characters for
NB. characters not in the alphabet. Therefore any non-alphabet character will
NB. cause a transition to the failure state
if. sparse do.
  trierow =: $. (1,1+#alphabet)$INTEGERZERO
else.
  trierow =: (1,1+#alphabet)$INTEGERZERO
end.
  
trie =: trierow,trierow
current_state=: 1
max_rows=: 1
)

destroy =: 3 : 0
NB. release any resources acquired

codestroy''   NB. release the instance, when it finishes execution
)

char_ins=: 3 : 0
next_state =. (<current_state,alphabet i. y){trie
smoutput next_state
if. INTEGERZERO = next_state do.
  NB. adding in new transition
  trie =: trie,trierow
  max_rows=: max_rows+1
  trie=: max_rows (<current_state,alphabet i. y)}trie
  current_state =: max_rows
else.
  NB. transition for the letter already exists
  NB. just transition to the next state
  current_state =: next_state
end.
)

strval_ins =: 4 : 0
NB. encode a string into the trie and place the value y
NB. in its end recognition state
_1 char_ins\x
trie =: y (<current_state,0)}trie
current_state =: 1
)

NB. inc_lookup a verb to use with \ to ratchet letters of a string
NB. through the trie
NB. usage to check a string: '_1 inc_lookup\<your word>'
NB. after running current state will be in a recognition state or
NB. state 0 indicating word not in trie
inc_lookup =: 3 : 0
current_state =: (<current_state,alphabet i. y){trie
)

NB. routine that returns the next state based on character presented
NB. this is set up to be used by fold:
NB.   1 ] F:. flookup 'bachelor'
NB. the big difference in this usage is the fold is terminated as soon
NB. as a failed transition occurs. This should facilitate word-piece 
NB. tokenizing.
flookup =: 4 : 0
NB. y is the current state
NB. x is the character to transition on 
ns =. (<y,alphabet i. x){trie
if. ns = 0 do. 
  NB. 2 reasons we get here
  NB. the string does not exist in the trie
  NB. we may have recognized a portion of the string as 
  NB. being in the trie
  NB. use Z: to interupt further folding
  1 Z: 1
  0
  return. 
end.
ns
)


NB. some routines for testing purposes

NB. a naive tokenization is to just to test words against a trie
NB. for that we can just use the '\' operator as follows
naive_tok =: 3 : 0
current_state =: 1
_1 inc_lookup\y
(<current_state,0){trie
)

NB. a naive tokenizer using fold
NB. this hides the fact that fold will stop as soon as you hit 
NB. a transition to the 0 state. If you run the fold as:
NB. 1 ] F:. flookup '<string>'
NB. the output is the complete list of state transitions. 
NB. if the last state is 0 then unrecognized
NB. otherwise use the last state to look up the integer token
ftok =: 3 : 0
current_state =: 1
states =. current_state ] F:. flookup y
(<(_1 {. states),0){trie
)

