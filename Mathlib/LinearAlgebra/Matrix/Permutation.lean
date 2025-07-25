/-
Copyright (c) 2020 Anne Baanen. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Anne Baanen
-/

import Mathlib.Data.Matrix.PEquiv
import Mathlib.Data.Set.Card
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# Permutation matrices

This file defines the matrix associated with a permutation

## Main definitions

- `Equiv.Perm.permMatrix`: the permutation matrix associated with an `Equiv.Perm`

## Main results

- `Matrix.det_permutation`: the determinant is the sign of the permutation
- `Matrix.trace_permutation`: the trace is the number of fixed points of the permutation

-/

open Equiv

variable {n R : Type*} [DecidableEq n] (σ : Perm n)

variable (R) in
/-- the permutation matrix associated with an `Equiv.Perm` -/
abbrev Equiv.Perm.permMatrix [Zero R] [One R] : Matrix n n R :=
  σ.toPEquiv.toMatrix

namespace Matrix

@[simp]
lemma transpose_permMatrix [Zero R] [One R] : (σ.permMatrix R).transpose = (σ⁻¹).permMatrix R := by
  rw [← PEquiv.toMatrix_symm, ← Equiv.toPEquiv_symm, ← Equiv.Perm.inv_def]

@[simp]
lemma conjTranspose_permMatrix [NonAssocSemiring R] [StarRing R] :
    (σ.permMatrix R).conjTranspose = (σ⁻¹).permMatrix R := by
  simp only [conjTranspose, transpose_permMatrix, map]
  aesop

variable [Fintype n]

/-- The determinant of a permutation matrix equals its sign. -/
@[simp]
theorem det_permutation [CommRing R] : det (σ.permMatrix R) = Perm.sign σ := by
  rw [← Matrix.mul_one (σ.permMatrix R), PEquiv.toMatrix_toPEquiv_mul,
    det_permute, det_one, mul_one]

/-- The trace of a permutation matrix equals the number of fixed points. -/
theorem trace_permutation [AddCommMonoidWithOne R] :
    trace (σ.permMatrix R) = (Function.fixedPoints σ).ncard := by
  delta trace
  simp [toPEquiv_apply, ← Set.ncard_coe_finset, Function.fixedPoints, Function.IsFixedPt]

end Matrix
