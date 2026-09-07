# Lean 4, Fall 2026

From: Sullivan · September 2, 2026

Every once in a while I try to take a quick snapshot of where we are today regarding the impact of Lean 4 beyond research. The numbers here could be off, so don't quote them, but they're ballpark right at a glance. This'll go to students in class, but figured I'd post it here, too, FYI. Best wishes for a good Fall.

| Organization | Valuation | Lean 4 work |
|---|---|---|
| **Microsoft** | $3.69T [2] | originated Lean; Aeneas-based Lean verification of Rust SymCrypt, with ML-KEM and SHA-3 proofs now shipping in Windows Insider builds [13] |
| **Amazon / AWS** | $2.75T [3] | Cedar authorization language, modelled in Lean and differentially tested against the production Rust [14]; the proofs found 4 validator bugs and testing found 21 more [15] |
| **Nethermind** | private | EVM and Yul semantics in Lean, passing 99.99% (22,330/22,332) of the Cancun execution tests [27]; Halva found a Keccak-256 bug in Scroll's circuit [28] |
| **Galois** | private | FVSpec: 2,772 property-based tests translated into 9,415 Lean 4 specifications [29][30] |
| **ByteDance** | >$600B [6] (proposed sale) | BFS-Prover, best-first search over Lean 4, open-sourced; 72.95% on MiniF2F [18] |
| **Tencent** | $503B [7] | HunyuanProver: data synthesis at scale with guided tree search [19] |
| **DeepSeek** | ~$74B [8] (round open) | DeepSeek-Prover-V2, subgoal decomposition by RL; 88.9% on MiniF2F-test [20] |
| **Moonshot AI** | ~$50B [9] (round open, pre-money) | Kimina-Prover, built with Project Numina [21] |
| **Google DeepMind** | Alphabet $4.13T [1] | AlphaProof: reinforcement learning over Lean; olympiad-level formal reasoning, published in Nature [12] |
| **Mistral AI** | ~$23B [10] (reported, in talks) | Leanstral, the first open-source code agent designed for Lean 4, Apache 2.0 [22] |
| **Harmonic** | $1.45B [11] | Aristotle: formally verified gold-medal-level performance at IMO 2025 [23] |
| **Math, Inc.** | undisclosed | Gauss completed the Tao–Kontorovich challenge to formalize the strong Prime Number Theorem in Lean [24]; OpenGauss released MIT-licensed [25] |
| **Huawei** | employee-owned | Mathesis: natural language to Lean 4 via an RL-trained autoformalizer [26] |
| **Anthropic** | $965B [4] | Claude raised a lower bound on zeta zeros from 41.6% to 67.2%, with a Lean formalization that passes the standard validation tool [16] |
| **OpenAI** | $852B [5] | ten decade-open problems, each shipped with a Lean 4 certificate [17] |

Market caps retrieved 2 Sept 2026, in USD. Tencent is reported by some aggregators at roughly twice the figure above; this follows the exchange's own arithmetic — HKD 438.20 × 9.00B shares = HKD 3.94T, about $503B. Tags in parentheses mark figures that are not completed rounds.

Sources: https://kevinsullivan.github.io/Lean4CS1/lean4-fall-2026-sources.html
