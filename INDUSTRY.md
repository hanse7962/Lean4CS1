# Lean 4, Fall 2026

*From: Sullivan · September 2, 2026*

Every once in a while I try to take a quick snapshot of where we are today regarding the
impact of Lean 4 beyond research. The numbers here could be off, so don't quote them, but
they're ballpark right at a glance. This'll go to students in class, but figured I'd post it
here, too, FYI. Best wishes for a good Fall.

## What the Lean work is for

| | Category | Organizations |
|---|---|---|
| ◼ | **Production software, formally verified** | Microsoft · AWS · Nethermind · Galois |
| ◼ | **AI solving already-formalized problems** | Tencent · ByteDance · DeepSeek · Moonshot |
| ◼ | **Informal mathematics into formal** | Google DeepMind · Huawei · Mistral · Harmonic · Math, Inc. |
| ◼ | **New mathematics, machine-checkable** | Anthropic · OpenAI |

## Fifteen organizations, by scale

| Organization | Founded | Valuation | Lean 4 activity | Emphasis |
|---|---|---|---|---|
| **Google DeepMind / Alphabet** | 2010 / 1998 | $4.13T [1] | **AlphaProof** — reinforcement learning over Lean; olympiad-level formal reasoning, published in *Nature* [12] | Autoformalization |
| **Microsoft** | 1975 | $3.69T [2] | Originated Lean. **Aeneas**-based Lean verification of Rust SymCrypt: "complete proofs for the Rust ML-KEM and SHA3 code that is being used in insiders builds of Windows today" [13] | Verified production |
| **Amazon / AWS** | 1994 | $2.75T [3] | **Cedar** authorization language, modelled in Lean and differentially tested against the production Rust [14]; the proofs found 4 validator bugs and testing found 21 more [15] | Verified production |
| **Anthropic** | 2021 | $965B [4] | Claude raised a lower bound on zeta zeros "from 41.6% to 67.2%"; the Lean formalization "passes the standard validation tool comparator" [16] | New mathematics |
| **OpenAI** | 2015 | $852B [5] | Public repository of "Lean certificates accompanying ten proofs in mathematics and theoretical computer science" [17] | New mathematics |
| **ByteDance** | 2012 | >$600B [6]<br>*proposed sale* | **BFS-Prover** — best-first search over Lean 4, open-sourced; 72.95% on MiniF2F [18] | Theorem proving |
| **Tencent** | 1998 | $503B [7] | **HunyuanProver** — scalable data synthesis with guided tree search for automated theorem proving [19] | Theorem proving |
| **DeepSeek** | 2023 | ~$74B [8]<br>*round open* | **DeepSeek-Prover-V2** — subgoal decomposition by reinforcement learning; 88.9% on MiniF2F-test [20] | Theorem proving |
| **Moonshot AI** | 2023 | ~$50B [9]<br>*round open, pre-money* | **Kimina-Prover** — "developed by Project Numina and Kimi teams … in Lean 4" [21] | Theorem proving |
| **Mistral AI** | 2023 | ~$23B [10]<br>*reported, in talks* | **Leanstral** — "the first open-source code agent designed for Lean 4", weights under Apache 2.0, evaluated on the Fermat's Last Theorem project [22] | Autoformalization |
| **Harmonic** | 2023 | $1.45B [11] | **Aristotle** — "among the first AI models to achieve formally verified gold medal-level performance on the 2025 International Mathematical Olympiad" [23] | Autoformalization |
| **Math, Inc.** | 2023 | Undisclosed | **Gauss** completed "a challenge set by Fields Medallist Terence Tao and Alex Kontorovich … to formalize the strong Prime Number Theorem (PNT) in Lean" [24]; **OpenGauss** released MIT-licensed [25] | Autoformalization |
| **Huawei** | 1987 | Employee-owned | **Mathesis** — natural language to Lean 4 via an RL-trained autoformalizer; released under the Huawei-AI4Math organization [26] | Autoformalization |
| **Nethermind** | 2017 | Private | EVM and Yul semantics in Lean, "passing 99.99% (22,330/22,332) of these Cancun execution tests" [27]; **Halva** found a Keccak-256 bug in Scroll's circuit [28] | Verified production |
| **Galois** | 1999 | Private | **FVSpec** — 2,772 property-based tests translated into "9,415 Lean 4 specifications" [29]; released under the GaloisInc organization [30] | Verified production |

Market capitalizations retrieved 2 September 2026 and quoted in USD. Tencent is reported by some
aggregators at roughly twice the figure above; the value here follows the exchange's own
arithmetic — HKD 438.20 × 9.00B shares = HKD 3.94T, about $503B at prevailing rates [7]. Italic
tags mark figures that are not completed rounds: DeepSeek's and Moonshot's raises were still
open, Mistral's is reported talks, and ByteDance's rests on a proposed equity sale. Founding
years are orientation only and were not source-checked.

The boundaries are soft. Harmonic, Mistral and Google DeepMind — and increasingly OpenAI and
Anthropic — work across specification, formalization and proof at once. ∎

## Sources

Every citation below was retrieved and read against the claim it supports, not merely checked
for a live URL. Figures are quoted from the cited page. Where a claim and a source parted
company, the claim was cut or re-sourced rather than kept.

1. StockAnalysis. "Alphabet (GOOGL) Market Cap." Retrieved 2 September 2026: "$4.13 trillion as of September 2, 2026." <https://stockanalysis.com/stocks/googl/market-cap/>
2. StockAnalysis. "Microsoft (MSFT) Market Cap." Retrieved 2 September 2026: "$3.69 trillion as of September 2, 2026." <https://stockanalysis.com/stocks/msft/market-cap/>
3. StockAnalysis. "Amazon (AMZN) Market Cap." Retrieved 2 September 2026: "$2.75 trillion as of September 2, 2026." <https://stockanalysis.com/stocks/amzn/market-cap/>
4. Anthropic. "Anthropic raises $65B in Series H funding at $965B post-money valuation." 28 May 2026. <https://www.anthropic.com/news/series-h>
5. Bellan, Rebecca. "OpenAI, not yet public, raises $3B from retail investors in monster $122B fund raise." *TechCrunch*, 31 March 2026. <https://techcrunch.com/2026/03/31/openai-not-yet-public-raises-3b-from-retail-investors-in-monster-122b-fund-raise/>
6. Feng, Coco. "ByteDance valuation surges to record high of over US$600b on proposed equity sale: sources." *South China Morning Post*, 8 April 2026. <https://www.scmp.com/tech/big-tech/article/3349337/bytedance-valuation-surges-record-high-over-us600b-proposed-equity-sale-sources>
7. StockAnalysis. "Tencent Holdings (HKG:0700)." Retrieved 2 September 2026: price HKD 438.20, shares outstanding 9.00B, market cap HKD 3.94T. Corroborated by the USD listing at $502.9B. <https://stockanalysis.com/quote/hkg/0700/>
8. PYMNTS. "DeepSeek Resumes Funding Round to Raise $8 Billion." 6 August 2026. Round ongoing: "The discussions are ongoing, and the details could change." <https://www.pymnts.com/news/artificial-intelligence/2026/deepseek-resumes-funding-round-to-raise-8-billion/>
9. KrASIA. "Moonshot AI targets August 27 closing for pre-IPO round ahead of Hong Kong filing." 11 August 2026: "The round, which is underway, values Moonshot AI at about USD 50 billion on a pre-money basis." <https://kr-asia.com/moonshot-ai-targets-august-27-closing-for-pre-ipo-round-ahead-of-hong-kong-filing>
10. Iyer, Ram. "Mistral is rumored to be raising €3B at €20B valuation." *TechCrunch*, 12 June 2026. In early discussions; €20B ≈ $23.15B. <https://techcrunch.com/2026/06/12/mistral-is-rumored-to-be-raising-e3b-at-e20-valuation/>
11. Riley, Duncan. "Harmonic AI raises $120M at $1.45B valuation to advance mathematical reasoning." *SiliconANGLE*, 25 November 2025. Series C, led by Ribbit Capital. <https://siliconangle.com/2025/11/25/harmonic-ai-raises-120m-1-45b-valuation-advance-mathematical-reasoning/>
12. Hubert, Thomas, Rishi S. Mehta, Laurent Sartran, et al. "Olympiad-level formal mathematical reasoning with reinforcement learning." *Nature*, 12 November 2025. DOI [10.1038/s41586-025-09833-y](https://doi.org/10.1038/s41586-025-09833-y); PMID 41225005.
13. Ho, Son, Cédric Fournet, Antoine Delignat-Lavaud, Samuel Lee, Jason Fisher and Jessica Krynitsky. "Verifying Rust cryptography in SymCrypt, from standards to code." *Microsoft Research Blog*, 13 July 2026. <https://www.microsoft.com/en-us/research/blog/verifying-rust-cryptography-in-symcrypt-from-standards-to-code/>
14. Hietala, Kesha and Emina Torlak. "Lean Into Verified Software Development." *AWS Open Source Blog*, 8 April 2024. <https://aws.amazon.com/blogs/opensource/lean-into-verified-software-development/>
15. Disselkoen, Craig, Aaron Eline, Shaobo He, et al. "How We Built Cedar: A Verification-Guided Approach." arXiv:2407.01688 [cs.SE], 1 July 2024: "we found and fixed 4 bugs in Cedar's policy validator, and DRT and PBT helped us find and fix 21 additional bugs." <https://arxiv.org/abs/2407.01688>
16. Anthropic. "Learning more about Claude's mathematical capabilities." 10 August 2026. <https://www.anthropic.com/research/riemann-zeta>
17. OpenAI. "ten-proofs: Lean certificates accompanying ten proofs in mathematics and theoretical computer science." GitHub. <https://github.com/openai/ten-proofs>
18. ByteDance Seed. "Seed Research | New SOTA in Formal Mathematical Reasoning! BFS-Prover Model Now Open Sourced." 25 February 2025. <https://seed.bytedance.com/en/blog/seed-research-new-sota-in-formal-mathematical-reasoning-bfs-prover-model-now-open-sourced>
19. Li, Yang, Dong Du, Linfeng Song, Chen Li, Weikang Wang, Tao Yang and Haitao Mi. "HunyuanProver: A Scalable Data Synthesis Framework and Guided Tree Search for Automated Theorem Proving." arXiv:2412.20735, 30 December 2024. <https://arxiv.org/abs/2412.20735>
20. Ren, Z. Z., Zhihong Shao, Junxiao Song, et al. "DeepSeek-Prover-V2: Advancing Formal Mathematical Reasoning via Reinforcement Learning for Subgoal Decomposition." arXiv:2504.21801, 30 April 2025 (rev. 18 July 2025). <https://arxiv.org/abs/2504.21801>
21. Project Numina and Kimi. "Kimina-Prover-72B" model card. Hugging Face, AI-MO/Kimina-Prover-72B. <https://huggingface.co/AI-MO/Kimina-Prover-72B>
22. Mistral AI. "Leanstral: Open-Source foundation for trustworthy vibe-coding." 16 March 2026. <https://mistral.ai/news/leanstral/>
23. Harmonic (Business Wire). "Harmonic Announces IMO Gold Medal-Level Performance & Launch of First Mathematical Superintelligence (MSI) AI App." 28 July 2025. <https://finance.yahoo.com/news/harmonic-announces-imo-gold-medal-224200822.html>
24. Math, Inc. "Introducing Gauss, an agent for autoformalization." <https://www.math.inc/gauss>
25. Math, Inc. "OpenGauss: an open source, state of the art autoformalization harness." <https://www.math.inc/opengauss>; source at <https://github.com/math-inc/OpenGauss> (MIT).
26. Yu, Xuejun, Jianyuan Zhong, Zijin Feng, et al. "Mathesis: Towards Formal Theorem Proving from Natural Languages." arXiv:2506.07047, 8 June 2025. <https://arxiv.org/abs/2506.07047>; code at <https://github.com/Huawei-AI4Math/Mathesis>.
27. Nethermind Security, Formal Verification Team. "How We Formalized Ethereum Execution: A Trustworthy Semantics of the EVM and Yul in Lean for Cancun." 6 February 2026. <https://www.nethermind.io/blog/a-trustworthy-formal-model-of-evm-yul-in-lean>
28. Nethermind Security, Formal Verification Team. "Formal Verification of Halo2 Circuits in Lean." 2 July 2025. <https://www.nethermind.io/blog/formal-verification-of-halo2-circuits-in-lean>
29. Dougherty, Quinn, Max von Hippel, Simon Henniger, Hazel Shackleton and Mike Dodds. "FVSpec: Real-World Property-Based Tests as Lean Challenges." arXiv:2606.01008, 31 May 2026 (rev. 17 August 2026). <https://arxiv.org/abs/2606.01008>
30. Galois, Inc. "fvspec: Benchmark suite for helping evaluate how AIs perform on formal verification related tasks." GitHub. <https://github.com/GaloisInc/fvspec>
