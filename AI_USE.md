# AI Use Disclosure — PA1

_Generative AI is allowed on PA1 as a tutor, reviewer, debugging partner and
helper with tooling. It is not allowed to be the author of your work. See the PA1
brief, "AI, Authorship and You". Fill in every section. "None" is an acceptable
answer only if it is true._

## 1. Did you use generative AI on this assignment?

- [ ] No. I did not use any generative AI tool for any part of PA1.
- [X] Yes, as described below.

## 2. Statement (the syllabus form)

> The author acknowledges the utilization of Claude, a language model
> developed by Anthropic, in the preparation of this assignment.
> Claude was used for assistance with understanding networking concepts, troubleshooting errors, reviewing code, and improving documentation.

## 3. Log

_One row per substantive interaction. Summaries are fine; you do not need to paste
whole conversations, but keep them in case you are asked._

| # | What I asked (summary) | What I used from the answer | What I changed or rejected | How I checked it was right |
|---|---|---|---|---|
| 1 |Questions about TCP sockets and message framing|Explanations of networking concepts|Applied the concepts to my implementation|Reviewed the protocol specifications|
| 2 |Help understanding errors during testing|Debugging suggestions|Evaluated and applied relevant fixes|Ran the self check|
| 3 |Suggestions for testing file transfers|Test Ideas|Adapted the tests to the project|Verified LIST, GET, and PUT|
| 4 |Help reviewing documentation|Suggestions for clarity and organization|Revised the wording|Compared it with the source code|
| 5 |Help developing an integration test|AI assisted Bash test script|Added it to the project|Ran the script and confirmed all tests passed|

## 4. Where AI-produced material remains

Claude assisted with developing tests/test_integration.sh, which tests the client and server using LIST, GET, PUT, and SHA 256 verification. 
AI assistance was also used to review and improve portions of README.md and DESIGN.md.

## 5. One thing the AI got wrong — or how you checked it

I did not rely on AI suggestions without verifying them. I compared the recommendations against the ETP/1 specification and tested the implementation using the course provided self-check. I also ran the AI-assisted integration test to verify communication between the client and server, including LIST, GET, PUT, and SHA 256 verification.
All 24 self-check tests passed, resulting in a score of 30/30 execution points
