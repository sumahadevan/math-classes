(* "Forgetting" an algebra's operations (but keeping the setoid equality) is a trivial functor.

This functor should nicely compose with the one forgetting variety laws. *)

Require Import
  Morphisms Setoid abstract_algebra universal_algebra theory.categories.
Require
  categories.setoid categories.product categories.algebra.

Section contents.

  Variable sign: Signature.

  Notation TargetObject := (product.Object (fun _: sorts sign => setoid.Object)).

  Let TargetArrows: Arrows TargetObject := @product.pa _ (fun _: sorts sign => setoid.Object) (fun _ => _: Arrows setoid.Object).
    (* hm, not happy about this *)

  Definition object (v: algebra.Object sign): TargetObject := fun i => setoid.object (v i) (algebra.algebra_equiv sign v i) _.
 
  Global Program Instance: Fmap object := fun _ _ => id.
  Next Obligation. destruct x. simpl. apply _. Qed.

  Global Instance forget: Functor object _.
  Proof.
   constructor.
     constructor; try apply _.
     intros x y E i A B F. simpl in *.
     unfold id.
     destruct (@homo_proper _ _ _ _ _ _ _ (proj1_sig x) (proj2_sig x) i).
     (* todo: shouldn't be necessary. perhaps an [Existing Instance] for
       a specialization of proj2_sig is called for. *)
     rewrite F. apply E.
    repeat intro. assumption.
   intros ? ? ? f g i ? ? E.
   simpl in *. unfold Basics.compose.
   destruct (@homo_proper _ _ _ _ _ _ _ (proj1_sig f) (proj2_sig f) i). (* todo: clean up *)
   destruct (@homo_proper _ _ _ _ _ _ _ (proj1_sig g) (proj2_sig g) i).
   rewrite E. reflexivity.
  Qed.

  (* Unfortunately we cannot also define the arrow in Cat because this leads to
   universe inconsistencies. Todo: look into this. *)

  Let hintje: forall x y, Equiv (object x --> object y). intros. apply _. Defined. (* todo: shouldn't be necessary *)

  Global Instance mono: forall (X Y: algebra.Object sign) (a: X --> Y),
    Mono (@fmap _ _ _ TargetArrows object _ _ _ a) -> (* todo: too ugly *)
    Mono a.
  Proof with simpl in *; intuition.
   repeat intro.
   destruct a as [? [? ?]].
   assert (fmap object f == fmap object g).
    apply H.
    repeat intro...
    destruct f as [? [? ?]].
    simpl in *.
    pose proof (H0 i).
    rewrite H1...
   apply H1...
  Qed.

End contents.
