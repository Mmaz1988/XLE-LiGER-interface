--replace(true);


#a TNS-ASP #b & #a s:: #c ==> #a SEM #c & #c TEMP-REF #d & #d T-REF 'undefined' & #c SIT #s.
#a PTYPE 'sem' ==> #a SEM #b & #b SIT #s.

//Tier 1 rules
#a TNS-ASP #b TENSE 'past' & #a SEM #c TEMP-REF #d & #d T-REF 'undefined' ==>  #d T-REF 'past' & #d EVAL #e & #e CHECK '-'.
#a TNS-ASP #b TENSE 'pres' & #a SEM #c TEMP-REF #d & #d T-REF 'undefined' ==>  #d T-REF 'pres' & #d EVAL #e & #e CHECK '-'.
#a TNS-ASP #b TENSE 'fut' & #a SEM #c TEMP-REF #d & #d T-REF 'undefined' ==>  #d T-REF 'fut' & #d EVAL #e & #e CHECK '-'.

//#a TNS-ASP #b TENSE 'pres' & #a SEM #c ==> #c TEMP-REF #d & #d T-REF 'pres' & #d EVAL #e & #e TIME 'now'.
//#a TNS-ASP #b TENSE 'fut' & #a SEM #c ==> #c TEMP-REF #d & #d T-REF 'fut' & #d EVAL #e & #e TIME 'now'.

//Tier 2 rules
//SOT rule
#a T-REF 'past' &
#a EVAL #z CHECK '-' &
#a ^(TEMP-REF>SEM>COMP) #b & #b !(SEM>TEMP-REF) #c T-REF 'past' ==> #a T-REF 'non-future' & #z CHECK '+' & #a EVAL #c.


//Relative tense rules
#a T-REF 'undefined' &
#a ^(TEMP-REF>SEM>XCOMP) #b & #b !(SEM>TEMP-REF) #c EVAL #d ==> #a EVAL #c.

//Aspect rules
#a TNS-ASP #b PROG '+_' & #a SEM #c ==> #c VIEWPOINT #d & #d ASPECT 'impv' & #d A-RESTR 'ongoing'.
#a TNS-ASP #b PROG '-_' & #a SEM #c ==> #c VIEWPOINT #d & #d ASPECT 'prv' & #d A-RESTR 'bounded'.
#a TNS-ASP #b PERF '+_' & #a SEM #c ==> #c ASP-TENSE #d & #d A-REF 'past'.

//Tier 2 aspect example
#a T-REF 'undefined' &
#a ^(TEMP-REF) #b ^(SEM>XCOMP) #c & #c !(SEM>TEMP-REF) #d EVAL #e &
#b VIEWPOINT #f ASPECT 'prv'
==>  #a T-REF 'future' & #a EVAL #d.


//Semantic interpretation
#g NTYPE #h & #g PRED %g
==> #g SEM #i & #i GLUE strip(%g) : #i.

//NP Quantifier -- Sem structure
#g ^(SPEC) #h & #g QUANT #i & #h SEM #l ==> #l VAR #j & #l RESTR #k & #l SIT #s.
#g ^(SPEC) #h & #g DET #i & #h SEM #l ==> #l VAR #j & #l RESTR #k & #l SIT #s.

//relative clause (with who)
#a PRED %a & #a PRON-REL #b & #a SUBJ #b &
#a SEM #z & #b SEM #y &
#a ^(in_set>ADJUNCT) #c SEM #d VAR #e & #d RESTR #f 6 #d SIT #s
==> #y GLUE [/P_<e,t>.[/Q_<e,t>.[/x_e.(P(x) \& Q(x))]]] : ((#e -o #f) -o ((#y -o #z) -o (#e -o #f))).

//NP Quantifier instantiation

//Universal quantifier
#g ^(SPEC) #h SEM #i VAR #j & #i RESTR #k & #i SIT #s &
#g QUANT #l PRED %l & %l == 'every' &
#h ^(%) #m SEM #n FPS #b & #n SIT #o
==> #i GLUE [/P_<e,<s,t>>.[/Q_<e,<s,t>>.[/s_s.Ax_e[P(x)(s) -> Q(x)(s)]]]] : ((#j -o (#s -o #k)) -o ((#i -o (#o -o #n)) -o (#o -o #n))).

//Existential quantifier
#g ^(SPEC) #h SEM #i VAR #j & #i RESTR #k & #i SIT #s &
#g DET #l DET-TYPE 'indef' &
#h ^(%) #m SEM #n SIT #o
==> #i GLUE [/P_<e,<s,t>>.[/Q_<e,<s,t>>.[/s_s.Ex_e[P(x)(s) \& Q(x)(s)]]]] : ((#j -o (#s -o #k)) -o ((#i -o (#o -o #n)) -o (#o -o #n))).


#g ^(SPEC) #h SEM #i VAR #j & #i RESTR #k & #i SIT #s &
#g DET #l DET-TYPE 'def'
==> #i GLUE [/P_<e,<s,t>>.Ix_e[P(x)]] : ((#j -o (#s -o #k)) -o #i).

//==> #i SIT #s & #i GLUE [/P_<e,<s,t>>.[/Q_<e,<s,t>>.[/s_s.the(P(x)(s),Q(x)(s))]]] : ((#j -o (#s -o #k)) -o ((#i -o (#o -o #n)) -o (#o -o #n))).


//predicates for Quantifiers
#g SEM #j VAR #i & #j RESTR #k & #j SIT #a & #g PRED %g ==> #a GLUE [/x_e.[/s_s.strip(%g)(x,s)]] : (#i -o (#a -o #k)).


//modification
#g SEM #j VAR #i & #j RESTR #k & #j SIT #l &
#g ADJUNCT #e in_set #h OBJ #m SEM #a  & #h SEM #b SIT #c
==> #h GLUE [/P_<e,<s,t>>.[/Q_<e,<s,t>>.[/x_e.[/s_s.(P(x)(s) \& Q(x)(s))]]]] : ((#j -o (#c -o #b)) -o ((#i -o (#l -o #k)) -o (#i -o (#l -o #k)))) &
 #e GLUE [/y_e.[/x_e.[/s_s.with(x,y,s)]]] : (#a -o (#j -o (#c -o #b))).

//FPS rules
//#a s:: #b ==> #a SEM #b.

//#a SEM #z FPS #y & #a PRED %a ==> #x GLUE [/e_v.strip(%a)(e)] : (#x -o #y).

#a XP #b REF 'unspec' & #b TYPE 'rheme' ==> #b GLUE y : #b.


//RES
#a XP #b &
#b REF #c &
#b TYPE 'possession' &
#a resP #d &
#d RES #e &
#d R-SUBJ #f ==>
#b GLUE [/x_e.[/y_e.[/e_v.(have(e) \& (ag(e,x) \& th(e,y)))]]] : (#f -o (#c -o (#e -o #b))) &
#d GLUE [/P_<e,<v,t>>.[/x_e.[/e_v.(res(e,x) \& P(x)(e))]]] : ((#f -o (#e -o #b)) -o (#f -o (#e -o #d))).

//PROC
//#d SEM #z FPS #b procP #c PROC #d & #c P-SUBJ 'undefined' &
//#b resP #g RES #d &
//#b XP #f TYPE 'possession' & #f REF #j ==>
//#c GLUE [/P_<v,t>.[/e_v.Ee1_v[Ee2_v[equals(e,to(e1,e2)) \& (proc(e1) \& P(e2))]]]] : ((#d -o #g) -o (#d -o #c)).

//#a SEM #z FPS #b procP #c PROC #d & #c P-SUBJ #e & #b XP #f TYPE 'rheme' ==>
//#c GLUE [/y_s.[/x_e.[/e_v.proc(e,x,y)]]] : (#f -o (#e -o (#d -o #c))).


#a SEM #z FPS #b PROCESS #c PROC-EV #d & #c UNDERGOER #e ==>
#c GLUE [/x_e.[/e_v.proc(e,x,y)]] : (#e -o (#d -o #c)).


//INIT
#a SEM #z FPS #b INITIATION #c INITIATOR #d & #c INIT-EV #h & #b PROCESS #e PROC-EV #f ==>
#c GLUE [/P_<v,t>.[/x_e.[/e_v.Ee1_v[Ee2_v[equals(e,to(e1,e2)) \& (init(e1,x) \& P(e2))]]]]] : ((#f -o #e) -o (#d -o (#h -o #c))).

#a SEM #z FPS #b INITIATION #c INITIATOR #d & #c INIT-EV #h & #b PROCESS #e PROC-EV #f & #e UNDERGOER #d ==>
#c GLUE [/P_<e,<v,t>>.[/x_e.[/e_v.Ee1_v[Ee2_v[equals(e,to(e1,e2)) \& (init(e1,x) \& P(x)(e2))]]]]] : ((#d -o (#f -o #e)) -o (#d -o (#h -o #c))).


//Subcategorization for verbs

//Transitive verbs -- Type A
#a SUBJ #b & #a OBJ #c & #a TNS-ASP #d & #a PRED %a &
#a SEM #z FPS #e PROCESS #f UNDERGOER #c SEM #j &
#z SIT #y &
#e INITIATION #h INIT-EV #i & #h INITIATOR #b SEM #k ==>
#e GLUE [/R_<e,<e,<v,t>>>.[/x_e.[/y_e.[/s_s.[/e_v.(partOf(e,s) \& (strip(%a)(e) \& (R(x)(y)(e) \& (ag(e,x) \& pt(e,y)))))]]]]] : ((#b -o (#c -o (#i -o #h))) -o (#k -o (#j -o (#y -o (#h -o #e))))).

//Transitive verbs -- Type B
#a SUBJ #b & #a OBJ #c & #a TNS-ASP #d & #a PRED %a &
#a SEM #z FPS #e procP #f P-SUBJ #b SEM #j &
#z SIT #y &
#e initP #h INIT #i & #h I-SUBJ #b SEM #j &
#c SEM #k
==>
#e GLUE [/R_<e,<v,t>>.[/x_e.[/y_e.[/s_s.[/e_v.(partOf(e,s) \& (strip(%a)(e) \& (R(x)(e) \& (ag(e,x) \& pt(e,y)))))]]]]] : ((#b -o (#i -o #h)) -o (#j -o (#k -o (#y -o (#h -o #e))))).

//Ditransitive verb
#a SUBJ #b & #a OBJ #c & #a OBJ-TH #d & #a PRED %a &
#d SEM #h &
#a SEM #z FPS #e resP #f R-SUBJ #c SEM #g &
#z SIT #y &
#e initP #k INIT #l & #k I-SUBJ #b SEM #m ==>
#e GLUE [/R_<e,<e,<e,<v,t>>>>.[/x_e.[/y_e.[/z_e.[/s_s.[/e_v.(partOf(e,s) \& (strip(%a)(e) \& (R(x)(y)(z)(e) \& (ag(e,x) \& (theme(e,z) \& goal(e,y))))))]]]]]] : ((#b -o (#c -o (#d -o (#l -o #k)))) -o (#m -o (#g -o (#h -o (#y -o (#k -o #e)))))).


//intransitive ohne PFS
//#a SUBJ #b SEM #c &
//#a SEM #z FPS #f & #f CHECK #y &
//#z SIT #x ==>
//#f GLUE [/R_<v,t>.[/x_e.[/s_s.[/e_v.(R(e) \& (partOf(e,s) \& ag(e,x)))]]]] : ((#y -o #f) -o (#c -o (#x -o (#y -o #f)))).


//transitive ohne FPS
//#a SUBJ #b SEM #c & #a OBJ #d SEM #e &
//#a SEM #z FPS #f & #f CHECK #y & #z SIT #x ==>
//#f GLUE [/R_<v,t>.[/x_e.[/y_e.[/s_s.[/e_v.(R(e) \& (partOf(e,s) \& (ag(e,x) \& pt(e,y))))]]]]] : ((#y -o #f) -o (#c -o (#e -o (#x -o (#y -o #f))))).




//Verb template for comp verbs
#a SUBJ #b SEM #c &
#a SEM #j &
#a COMP #d SEM #e TEMP-REF #f EVAL #g T-REF %i &
#j FPS #h CHECK #i &
#j SIT #k
 ==> #h GLUE [/R_<v,t>.[/P_<s,t>.[/x_e.[/s_s.[/e_v.(R(e) \& (ag(e,x) \& th(e,P(s))))]]]]] : ((#i -o #h) -o ((#g -o #e) -o (#c -o (#k -o (#i -o #h))))).

//XCOMP
//Verb template for comp verbs
#a SUBJ #b SEM #c &
#a SEM #j &
#a XCOMP #d SEM #e TEMP-REF #f EVAL #g T-REF %i &
#j FPS #h CHECK #i &
#j SIT #k
 ==> #h GLUE [/R_<v,t>.[/P_<e,<s,t>>.[/x_e.[/s_s.[/e_v.(R(e) \& (partOf(e,s) \& (ag(e,x) \& th(e,P(x)(s)))))]]]]] : ((#i -o #h) -o ((#c -o (#g -o #e)) -o (#c -o (#k -o (#i -o #h))))).


//modification
#g SEM #j SIT #l & #j FPS #o CHECK #p &
#g ADJUNCT #e in_set #h OBJ #m SEM #a  & #h SEM #b SIT #c
==> #h GLUE [/P_<v,t>.[/Q_<s,<v,t>>.[/s_s.[/e_v.(P(e) \& Q(s)(e))]]]] : ((#p -o #b) -o ((#l -o (#p -o #o)) -o (#l -o (#p -o #o)))) &
 #e GLUE [/y_e.[/e_v.with(e,y)]] : (#a -o (#p-o #b)).

//Closure
#b FPS #c ==> #c CLOSURE #d.
#b FPS #c INITIATION #d & #c CLOSURE #e & #b SIT #f ==> #e GLUE [/P_<s,<v,t>>.[/s_s.Ee_v[P(s)(e)]]] : ((#f -o (#d -o #c)) -o (#f -o #b)).
//#b FPS #c CLOSURE #e & #c CHECK #z & #b SIT #f ==> #e GLUE [/P_<s,<v,t>>.[/s_s.Ee_v[P(s)(e)]]] : ((#f -o (#z -o #c)) -o (#f -o #b)).



//Rules for interpreting grammatical aspect
#a SEM #b VIEWPOINT #c ==>
#c VAR #d & #c RESTR #e &
#c ASP-RESTR' #f.


#a SEM #b VIEWPOINT #c A-RESTR 'ongoing' &
#c VAR #d & #c RESTR #e &
#c ASP-RESTR' #f ==>
#f GLUE [/s_s.[/t_s.ongoing(t,s)]] : (#d -o (#e -o #c)).

#a SEM #b VIEWPOINT #c A-RESTR 'bounded' &
#c VAR #d & #c RESTR #e &
#c ASP-RESTR' #f ==>
#f GLUE [/s_s.[/t_s.bounded(t,s)]] : (#d -o (#e -o #c)).


#a SEM #b VIEWPOINT #c ASPECT 'impv' &
#c VAR #d & #c RESTR #e &
#b TEMP-REF #f &
#b SIT #g
 ==>  #c GLUE [/M_<s,<s,t>>.[/P_<s,t>.[/s_s.Az_s[M(s)(z) -> P(z)]]]] : ((#d -o (#e -o #c)) -o ((#g -o #b) -o (#f -o #b))).

#a SEM #b VIEWPOINT #c ASPECT 'prv' &
#c VAR #d & #c RESTR #e &
#b TEMP-REF #f &
#b SIT #g
 ==>  #c GLUE [/M_<s,<s,t>>.[/P_<s,t>.[/s_s.Ez_s[M(s)(z) \& P(z)]]]] : ((#d -o (#e -o #c)) -o ((#g -o #b) -o (#f -o #b))).

//Tense values

//TODO make so that one tense restrictor works for both relative and absolute tenses

//Past reference
#a SEM #b TEMP-REF #c T-REF 'past' & #c EVAL #d CHECK '-' ==>
#c T-REF' #e & #e GLUE [/t_s.[/t2_s.before(t,t2)]] : (#c -o (#d -o #c)).

#a SEM #b TEMP-REF #c T-REF 'past' & #c EVAL #d T-REF %a ==>
#c T-REF' #e & #e GLUE [/t_s.[/t2_s.before(t,t2)]] : (#c -o (#d -o #c)).

//Non-future
#a SEM #b TEMP-REF #c T-REF 'non-future' & #c EVAL #d CHECK '-' ==>
#c T-REF' #e & #e GLUE {[/t_s.[/t2_s.before(t,t2)]],[/t_s.[/t2_s.overlap(t,t2)]]} : (#c -o (#d -o #c)).

#a SEM #b TEMP-REF #c T-REF 'non-future' & #c EVAL #d T-REF %a ==>
#c T-REF' #e & #e GLUE {[/t_s.[/t2_s.before(t,t2)]],[/t_s.[/t2_s.overlap(t,t2)]]} : (#c -o (#d -o #c)).

//Future reference
#a SEM #b TEMP-REF #c T-REF 'future' & #c EVAL #d CHECK '-' ==>
#c T-REF' #e & #e GLUE [/t_s.[/t2_s.after(t,t2)]] : (#c -o (#d -o #c)).

#a SEM #b TEMP-REF #c T-REF 'future' & #c EVAL #d T-REF %a ==>
#c T-REF' #e & #e GLUE [/t_s.[/t2_s.after(t,t2)]] : (#c -o (#d -o #c)).


//absolute tense closure
#a SEM #b TEMP-REF #c T-REF %a & %a != 'undefined' & #c EVAL #d CHECK '-'
==> #c GLUE [/T_<s,<s,t>>.[/P_<s,t>.[/s_s.Er_s[T(r)(s) \& P(r)]]]] : ((#c -o (#d -o #c)) -o ((#c -o #b) -o (#d -o #b))).

//relative tense closure
#a SEM #b TEMP-REF #c T-REF %a & %a != 'undefined' & #c EVAL #d T-REF %b
==> #c GLUE [/T_<s,<s,t>>.[/P_<s,t>.[/s_s.Er_s[T(r)(s) \& P(r)]]]] : ((#c -o (#d -o #c)) -o ((#c -o #b) -o (#d -o #b))).


//unspec absolute closure
#a SEM #b TEMP-REF #c T-REF %a & %a == 'undefined' & #c EVAL #d CHECK '-'
==> #c GLUE [/P_<s,t>.[/s_s.P(s)]] : ((#c -o #b) -o (#d -o #b)).

//unspec relative closure
#a SEM #b TEMP-REF #c T-REF %a & %a == 'undefined' & #c EVAL #d T-REF %b
==> #c GLUE [/P_<s,t>.[/s_s.P(s)]] : ((#c -o #b) -o (#d -o #b)).



#a SEM #b TEMP-REF #c T-REF 'pres' & #c EVAL #d ==> #c GLUE [/P_<s,t>.[/s_s.Er_s[equals(r,s) \& P(r)]]] : ((#c -o #b) -o (#d -o #b)).

// #a SEM #b ASP-TENSE #c A-REF 'past' & #b TEMP-REF #d ==>  #c GLUE [/P_<s,t>.[/s_s.Er_s[before(r,s) \& P(r)]]] : ((#d -o #b) -o (#d -o #b)).

#a SEM #b ASP-TENSE #c A-REF 'undefined' & #b TEMP-REF #d ==>  #c GLUE [/P_<s,t>.[/s_s.P(s)]] : ((#d -o #b) -o (#d -o #b)).

#a EVAL #b & #b CHECK '-' ==> #b GLUE now : #b.