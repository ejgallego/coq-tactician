open Ltac_plugin
open Map_all_the_things

open Ssrmatching_plugin
open Ssreflect_plugin
open Stdarg
open Extraargs
open Tacarg
open Taccoerce
open Ssrparser
open Ssrmatching
open Ssrequality
open G_auto
open Ground_plugin
open G_ground
open G_rewrite
open Recdef_plugin
open G_indfun
open Constrexpr
open Genintern
open Libnames
open Locus
open Names
open Loc
open Tactypes
open Tactics
open Tacexpr
open Ssrast

module OList = List

let at wit = register_generic_map_identity wit
let _ = [
  (* Stdarg *)
  at wit_unit; at wit_bool; at wit_int; at wit_string; at wit_pre_ident; at wit_ident;
  at wit_sort_family;

  (* Extraargs *)
  at wit_orient; at wit_rename; at wit_natural; at wit_test_lpar_id_colon;

  (* Tacarg *)
  at wit_quant_hyp;

  (* Taccoerce *)
  at wit_constr_context; at wit_constr_under_binders;

  (* G_auto *)
  at wit_hintbases;

  (* Ssrparser *)
  at wit_ssrseqdir; at wit_ssrfwdid; at wit_ssrfwdfmt; at wit_ssrdir;

  (* Ssrmatching *)
  at Internal.wit_rpatternty

  (* TODO: See if there is something that can be done for Ltac2 *)
]

let _ = register_generic_map wit_uconstr (module struct
    type raw = constr_expr
    type glob = glob_constr_and_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.constr_expr_map
      let glob_map m = m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_open_constr (module struct
    type raw = constr_expr
    type glob = glob_constr_and_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.constr_expr_map
      let glob_map m = m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_constr (module struct
    type raw = constr_expr
    type glob = glob_constr_and_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.constr_expr_map
      let glob_map m = m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_ref (module struct
    type raw = qualid
    type glob = GlobRef.t located or_var
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.cast_map id
      let glob_map m = m.or_var_map (m.located_map id)
    end
  end)

let _ = register_generic_map wit_hyp (module struct
    type raw = lident
    type glob = lident
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.cast_map id
      let glob_map m = m.cast_map id
    end
  end)

let _ = register_generic_map wit_int_or_var (module struct
    type raw = int or_var
    type glob = int or_var
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.or_var_map id
      let glob_map m = m.or_var_map id
    end
  end)

let _ = register_generic_map wit_clause_dft_concl (module struct
    type raw = lident clause_expr
    type glob = lident clause_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.clause_expr_map (m.cast_map id)
      let glob_map m = m.clause_expr_map (m.cast_map id)
    end
  end)

let _ = register_generic_map wit_hloc (module struct
    type raw = loc_place
    type glob = loc_place
    module M = functor (M : MapDef) -> struct
      open M
      let location_map f g = function
        | HypLocation x -> let+ x = f x in HypLocation x
        | ConclLocation x -> let+ x = g x in ConclLocation x
      let raw_map m = location_map (fun (a, b) -> let+ a = m.cast_map id a in a, b) id
      let glob_map m = location_map (fun (a, b) -> let+ a = m.cast_map id a in a, b) id
    end
  end)

let _ = register_generic_map wit_glob (module struct
    type raw = constr_expr
    type glob = glob_constr_and_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.constr_expr_map
      let glob_map m = m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_lconstr (module struct
    type raw = constr_expr
    type glob = glob_constr_and_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.constr_expr_map
      let glob_map m = m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_casted_constr (module struct
    type raw = constr_expr
    type glob = glob_constr_and_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.constr_expr_map
      let glob_map m = m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_in_clause (module struct
    type raw = lident clause_expr
    type glob = lident clause_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.clause_expr_map (m.cast_map id)
      let glob_map m = m.clause_expr_map (m.cast_map id)
    end
  end)

let _ = register_generic_map wit_occurrences (module struct
    type raw = int list or_var
    type glob = int list or_var
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.or_var_map id
      let glob_map m = m.or_var_map id
    end
  end)

let _ = register_generic_map wit_intro_pattern (module struct
    type raw = constr_expr intro_pattern_expr CAst.t
    type glob = glob_constr_and_expr intro_pattern_expr CAst.t
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.cast_map (m.intro_pattern_expr_map m.constr_expr_map)
      let glob_map m = m.cast_map (m.intro_pattern_expr_map m.glob_constr_and_expr_map)
    end
  end)

let _ = register_generic_map wit_simple_intropattern (module struct
    type raw = constr_expr intro_pattern_expr CAst.t
    type glob = glob_constr_and_expr intro_pattern_expr CAst.t
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.cast_map (m.intro_pattern_expr_map m.constr_expr_map)
      let glob_map m = m.cast_map (m.intro_pattern_expr_map m.glob_constr_and_expr_map)
    end
  end)

let _ = register_generic_map wit_constr_with_bindings (module struct
    type raw = constr_expr with_bindings
    type glob = glob_constr_and_expr with_bindings
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.with_bindings_map m.constr_expr_map
      let glob_map m = m.with_bindings_map m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_open_constr_with_bindings (module struct
    type raw = constr_expr with_bindings
    type glob = glob_constr_and_expr with_bindings
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.with_bindings_map m.constr_expr_map
      let glob_map m = m.with_bindings_map m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_bindings (module struct
    type raw = constr_expr bindings
    type glob = glob_constr_and_expr bindings
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.bindings_map m.constr_expr_map
      let glob_map m = m.bindings_map m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_destruction_arg (module struct
    type raw = constr_expr with_bindings destruction_arg
    type glob = glob_constr_and_expr with_bindings destruction_arg
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.destruction_arg_map (m.with_bindings_map m.constr_expr_map)
      let glob_map m = m.destruction_arg_map (m.with_bindings_map m.glob_constr_and_expr_map)
    end
  end)

let _ = register_generic_map wit_auto_using (module struct
    type raw = constr_expr list
    type glob = glob_constr_and_expr list
    module M = functor (M : MapDef) -> struct
      open M
      open Monad.Make(M)
      let raw_map m = List.map m.constr_expr_map
      let glob_map m = List.map m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_firstorder_using (module struct
    type raw = qualid list
    type glob = GlobRef.t located or_var list
    module M = functor (M : MapDef) -> struct
      open M
      open Monad.Make(M)
      let raw_map m = List.map (m.cast_map id)
      let glob_map m = List.map (m.or_var_map (m.located_map id))
    end
  end)

let _ = register_generic_map wit_glob_constr_with_bindings (module struct
    type raw = constr_expr with_bindings
    type glob = glob_constr_and_expr with_bindings
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.with_bindings_map m.constr_expr_map
      let glob_map m = m.with_bindings_map m.glob_constr_and_expr_map
    end
  end)

let _ = register_generic_map wit_fun_ind_using (module struct
    type raw = constr_expr with_bindings option
    type glob = glob_constr_and_expr with_bindings option
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.option_map (m.with_bindings_map m.constr_expr_map)
      let glob_map m = m.option_map (m.with_bindings_map m.glob_constr_and_expr_map)
    end
  end)

let _ = register_generic_map wit_with_names (module struct
    type raw = constr_expr intro_pattern_expr CAst.t option
    type glob = glob_constr_and_expr intro_pattern_expr CAst.t option
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.option_map (m.cast_map (m.intro_pattern_expr_map m.constr_expr_map))
      let glob_map m = m.option_map (m.cast_map (m.intro_pattern_expr_map m.glob_constr_and_expr_map))
    end
  end)

let at wit = register_generic_map wit (module struct
    type raw = raw_tactic_expr
    type glob = glob_tactic_expr
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.raw_tactic_expr_map
      let glob_map m = m.glob_tactic_expr_map
    end
  end)

let _ = [at wit_tactic; at wit_ltac; at wit_ssrtacarg; at wit_ssrtclarg]

let _ = register_generic_map wit_by_arg_tac (module struct
    type raw = raw_tactic_expr option
    type glob = glob_tactic_expr option
    module M = functor (M : MapDef) -> struct
      open M
      let raw_map m = m.option_map m.raw_tactic_expr_map
      let glob_map m = m.option_map m.glob_tactic_expr_map
    end
  end)

(* TODO: What is the runtime overhead of this? *)
module SSRMap (M : MapDef) = struct
  open M
  module OList = List
  include Monad.Make(M)

  let ssrterm_map m (k, c) =
    let+ c = m.glob_constr_and_expr_map c in (k, c)

  let ast_closure_term_map m ({body; _} as at) =
    let+ body = m.constr_expr_map body
    in {at with body}

  let ssrhyp_map m (SsrHyp h) =
    let+ h = m.located_map id h in SsrHyp h

  let ssrhyp_or_id_map m = function
    | Hyp h -> let+ h = ssrhyp_map m h in Hyp h
    | Id h  -> let+ h = ssrhyp_map m h in Hyp h

  let ssrhyps_map m = List.map (ssrhyp_map m)

  let ssripat_map m = function
    | IPatView v ->
      let+ v = List.map (ast_closure_term_map m) v in IPatView v
    | IPatClear c ->
      let+ c = ssrhyps_map m c in IPatClear c
    | x -> return x

  let ssripats_map m = List.map (ssripat_map m)

  let ssrhpats_map m (((clr, ipats1), ipats2), ipats3) =
    let+ clr = m.option_map (ssrhyps_map m) clr
    and+ ipats1 = ssripats_map m ipats1
    and+ ipats2 = ssripats_map m ipats2
    and+ ipats3 = ssripats_map m ipats3 in
    ((clr, ipats1), ipats2), ipats3

  let ssrhpats_wtransp_map m (b, ssrhpats) =
    let+ ssrhpats = ssrhpats_map m ssrhpats in (b, ssrhpats)

  let ssrdocc_map m (clr, occ) =
    let+ clr = m.option_map (ssrhyps_map m) clr in (clr, occ)

  let ssragens_map m f (doccs, clr) =
    let+ doccs = List.map (List.map (fun (docc, a) ->
        let+ docc = ssrdocc_map m docc
        and+ a = f a in (docc, a))) doccs
    and+ clr = ssrhyps_map m clr in
    (doccs, clr)

  (* TODO: We are blocked from accessing this one *)
  let cpattern_map m = id
  (* TODO: We are blocked from accessing this one *)
  let rpattern_map m = id

  let ssrarg_map m ((fwdview, (eqid, (agens, ipats))) : ssrarg) : ssrarg t =
    let+ fwdview = List.map (ast_closure_term_map m) fwdview
    and+ eqid = m.option_map (ssripat_map m) eqid
    and+ agens = ssragens_map m (cpattern_map m) agens
    and+ ipats = ssripats_map m ipats in
    (fwdview, (eqid, (agens, ipats)))

  let ssrrwarg_map m ((dir, mult), ((docc, rpat), (wkind, term)) : ssrrwarg) : ssrrwarg t =
    let+ docc = ssrdocc_map m docc
    and+ rpat = m.option_map (rpattern_map m) rpat
    and+ term = ssrterm_map m term in
    ((dir, mult), ((docc, rpat), (wkind, term)))

  let clause_map m (clr, x) =
    let+ clr = ssrhyps_map m clr
    and+ x = m.option_map (fun ((hyp_or_id, str), cpattern) ->
        let+ hyp_or_id = ssrhyp_or_id_map m hyp_or_id
        and+ cpattern = m.option_map (cpattern_map m) cpattern in
        ((hyp_or_id, str), cpattern)) x in
    (clr, x)

  let clauses_map m (cs, clseq) =
    let+ cs = List.map (clause_map m) cs in (cs, clseq)

  let ssrcasearg_map m f (ipat, (x, ipats)) =
    let+ ipat = m.option_map (ssripat_map m) ipat
    and+ x = f x
    and+ ipats = ssripats_map m ipats in
    (ipat, (x, ipats))

  let ssrmovearg_map m f (view, casearg) =
    let+ view = List.map (ast_closure_term_map m) view
    and+ casearg = ssrcasearg_map m f casearg in
    (view, casearg)

  let ssrapplyarg_map m (terms, (agens, ipats)) =
    let+ terms = List.map (ssrterm_map m) terms
    and+ agens = ssragens_map m (ssrterm_map m) agens
    and+ ipats = ssripats_map m ipats in
    (terms, (agens, ipats))

  let ssrhint_map m f (b, xs) =
    let+ xs = List.map (m.option_map f) xs in (b, xs)

  let ssrseqarg_map m f (index, (hint, x)) =
    let+ index = m.or_var_map id index
    and+ hint = ssrhint_map m f hint
    and+ x = m.option_map f x in
    (index, (hint, x))

  let ffwbinders_map m f ((hpats, ((fwdfmt, cl), hint)) : 'a ffwbinders) : 'a ffwbinders t =
    let+ hpats = ssrhpats_map m hpats
    and+ cl = ast_closure_term_map m cl
    and+ hint = ssrhint_map m f hint in
    (hpats, ((fwdfmt, cl), hint))

  let fwdbinders_map m f (b, x) =
    let+ x = ffwbinders_map m f x in (b, x)

  let ssrdoarg_map m f ((((index, mo), hint), cls) : 'a ssrdoarg) : 'a ssrdoarg t =
    let+ index = m.or_var_map id index
    and+ hint = ssrhint_map m f hint
    and+ cls = clauses_map m cls in
    ((index, mo), hint), cls
end

let _ = register_generic_map wit_ssripatrep (module struct
    type raw = ssripat
    type glob = ssripat
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssripat_map
      let glob_map = ssripat_map
    end
  end)

let _ = register_generic_map wit_ssrarg (module struct
    type raw = ssrarg
    type glob = ssrarg
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssrarg_map
      let glob_map = ssrarg_map
    end
  end)

let _ = register_generic_map wit_ssrrwargs (module struct
    type raw = ssrrwarg list
    type glob = ssrrwarg list
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map m = List.map (ssrrwarg_map m)
      let glob_map m = List.map (ssrrwarg_map m)
    end
  end)

let _ = register_generic_map wit_ssrclauses (module struct
    type raw = clauses
    type glob = clauses
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = clauses_map
      let glob_map = clauses_map
    end
  end)

let _ = register_generic_map wit_ssrcasearg (module struct
    type raw = cpattern ssragens ssrmovearg
    type glob = cpattern ssragens ssrmovearg
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map m = ssrmovearg_map m (ssragens_map m (cpattern_map m))
      let glob_map m = ssrmovearg_map m (ssragens_map m (cpattern_map m))
    end
  end)

let _ = register_generic_map wit_ssrmovearg (module struct
    type raw = cpattern ssragens ssrmovearg
    type glob = cpattern ssragens ssrmovearg
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map m = ssrmovearg_map m (ssragens_map m (cpattern_map m))
      let glob_map m = ssrmovearg_map m (ssragens_map m (cpattern_map m))
    end
  end)

let _ = register_generic_map wit_ssrapplyarg (module struct
    type raw = ssrapplyarg
    type glob = ssrapplyarg
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssrapplyarg_map
      let glob_map = ssrapplyarg_map
    end
  end)

let _ = register_generic_map wit_ssrcongrarg (module struct
    type raw = (int * ssrterm) * cpattern ssragens
    type glob = (int * ssrterm) * cpattern ssragens
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m ((i, term), agens) =
        let+ term = ssrterm_map m term
        and+ agens = ssragens_map m (cpattern_map m) agens in
        ((i, term), agens)
      let raw_map = map
      let glob_map = map
    end
  end)

let _ = register_generic_map wit_ssrhpats (module struct
    type raw = ssrhpats
    type glob = ssrhpats
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssrhpats_map
      let glob_map = ssrhpats_map
    end
  end)

let _ = register_generic_map wit_ssrhpats_nobs (module struct
    type raw = ssrhpats
    type glob = ssrhpats
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssrhpats_map
      let glob_map = ssrhpats_map
    end
  end)

let _ = register_generic_map wit_ssrsetfwd (module struct
    type raw = (ssrfwdfmt * (cpattern * ast_closure_term option)) * ssrdocc
    type glob = (ssrfwdfmt * (cpattern * ast_closure_term option)) * ssrdocc
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m ((fwdfmt, (cpattern, ct)), docc) =
        let+ cpattern = cpattern_map m cpattern
        and+ ct = m.option_map (ast_closure_term_map m) ct
        and+ docc = ssrdocc_map m docc in
        (fwdfmt, (cpattern, ct)), docc
      let raw_map = map
      let glob_map = map
    end
  end)

let _ = register_generic_map wit_ssrhpats_wtransp (module struct
    type raw = ssrhpats_wtransp
    type glob = ssrhpats_wtransp
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssrhpats_wtransp_map
      let glob_map = ssrhpats_wtransp_map
    end
  end)

let _ = register_generic_map wit_ssrposefwd (module struct
    type raw = ssrfwdfmt * ast_closure_term
    type glob = ssrfwdfmt * ast_closure_term
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m (fwdfmt, ct) =
        let+ ct = ast_closure_term_map m ct in (fwdfmt, ct)
      let raw_map = map
      let glob_map = map
    end
  end)

let _ = register_generic_map wit_ssrrpat (module struct
    type raw = ssripat
    type glob = ssripat
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssripat_map
      let glob_map = ssripat_map
    end
  end)

let _ = register_generic_map wit_ssrterm (module struct
    type raw = ssrterm
    type glob = ssrterm
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssrterm_map
      let glob_map = ssrterm_map
    end
  end)

let _ = register_generic_map wit_ssrunlockarg (module struct
    type raw = ssrocc * ssrterm
    type glob = ssrocc * ssrterm
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m (occ, term) =
        let+ term = ssrterm_map m term in (occ, term)
      let raw_map = map
      let glob_map = map
    end
  end)

let _ = register_generic_map wit_ssrunlockargs (module struct
    type raw = (ssrocc * ssrterm) list
    type glob = (ssrocc * ssrterm) list
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m (occ, term) =
        let+ term = ssrterm_map m term in (occ, term)
      let raw_map m = List.map (map m)
      let glob_map m = List.map (map m)
    end
  end)

let _ = register_generic_map wit_ssrwgen (module struct
    type raw = clause
    type glob = clause
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = clause_map
      let glob_map = clause_map
    end
  end)

let _ = register_generic_map wit_ssrwlogfwd (module struct
    type raw = clause list * (ssrfwdfmt * ast_closure_term)
    type glob = clause list * (ssrfwdfmt * ast_closure_term)
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m (cls, (fwdfmt, cl)) =
        let+ cls = List.map (clause_map m) cls
        and+ cl = ast_closure_term_map m cl in
        cls, (fwdfmt, cl)
      let raw_map = map
      let glob_map = map
    end
  end)

let _ = register_generic_map wit_ssrfixfwd (module struct
    type raw = Id.t * (ssrfwdfmt * ast_closure_term)
    type glob = Id.t * (ssrfwdfmt * ast_closure_term)
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m (id, (fwdfmt, cl)) =
        let+ cl = ast_closure_term_map m cl in
        id, (fwdfmt, cl)
      let raw_map = map
      let glob_map = map
    end
  end)

let _ = register_generic_map wit_ssrfwd (module struct
    type raw = ssrfwdfmt * ast_closure_term
    type glob = ssrfwdfmt * ast_closure_term
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m (fwdfmt, cl) =
        let+ cl = ast_closure_term_map m cl in
        fwdfmt, cl
      let raw_map = map
      let glob_map = map
    end
  end)

let _ = register_generic_map wit_ssrexactarg (module struct
    type raw = ssrapplyarg
    type glob = ssrapplyarg
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssrapplyarg_map
      let glob_map = ssrapplyarg_map
    end
  end)

let _ = register_generic_map wit_ssrcpat (module struct
    type raw = ssripat
    type glob = ssripat
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map = ssripat_map
      let glob_map = ssripat_map
    end
  end)

let _ = register_generic_map wit_ssrdgens (module struct
    type raw = cpattern ssragens
    type glob = cpattern ssragens
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map m = ssragens_map m (cpattern_map m)
      let glob_map m = ssragens_map m (cpattern_map m)
    end
  end)

let _ = register_generic_map wit_ssrdgens_tl (module struct
    type raw = cpattern ssragens
    type glob = cpattern ssragens
    module M = functor (M : MapDef) -> struct
      open SSRMap(M)
      let raw_map m = ssragens_map m (cpattern_map m)
      let glob_map m = ssragens_map m (cpattern_map m)
    end
  end)

let _ = register_generic_map wit_ssrseqarg (module struct
    type raw = raw_tactic_expr ssrseqarg
    type glob = glob_tactic_expr ssrseqarg
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let raw_map m = ssrseqarg_map m m.raw_tactic_expr_map
      let glob_map m = ssrseqarg_map m m.glob_tactic_expr_map
    end
  end)

let _ = register_generic_map wit_ssrintrosarg (module struct
    type raw = raw_tactic_expr * ssripats
    type glob = glob_tactic_expr * ssripats
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let map m f (tac, ipats) =
        let+ tac = f tac
        and+ ipats = ssripats_map m ipats in
        (tac, ipats)
      let raw_map m = map m m.raw_tactic_expr_map
      let glob_map m = map m m.glob_tactic_expr_map
    end
  end)

let _ = register_generic_map wit_ssrsufffwd (module struct
    type raw = raw_tactic_expr ffwbinders
    type glob = glob_tactic_expr ffwbinders
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let raw_map m = ffwbinders_map m m.raw_tactic_expr_map
      let glob_map m = ffwbinders_map m m.glob_tactic_expr_map
    end
  end)

let _ = register_generic_map wit_ssrhavefwdwbinders (module struct
    type raw = raw_tactic_expr fwdbinders
    type glob = glob_tactic_expr fwdbinders
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let raw_map m = fwdbinders_map m m.raw_tactic_expr_map
      let glob_map m = fwdbinders_map m m.glob_tactic_expr_map
    end
  end)

let _ = register_generic_map wit_ssrdoarg (module struct
    type raw = raw_tactic_expr ssrdoarg
    type glob = glob_tactic_expr ssrdoarg
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let raw_map m = ssrdoarg_map m m.raw_tactic_expr_map
      let glob_map m = ssrdoarg_map m m.glob_tactic_expr_map
    end
  end)

let _ = register_generic_map wit_ssrhint (module struct
    type raw = raw_tactic_expr ssrhint
    type glob = glob_tactic_expr ssrhint
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let raw_map m = ssrhint_map m m.raw_tactic_expr_map
      let glob_map m = ssrhint_map m m.glob_tactic_expr_map
    end
  end)

let _ = register_generic_map wit_ssrhintarg (module struct
    type raw = raw_tactic_expr ssrhint
    type glob = glob_tactic_expr ssrhint
    module M = functor (M : MapDef) -> struct
      open M
      open SSRMap(M)
      let raw_map m = ssrhint_map m m.raw_tactic_expr_map
      let glob_map m = ssrhint_map m m.glob_tactic_expr_map
    end
  end)
