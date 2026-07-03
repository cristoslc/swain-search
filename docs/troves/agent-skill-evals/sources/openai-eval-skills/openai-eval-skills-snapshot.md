---
slug: openai-eval-skills
title: "Testing Agent Skills Systematically with Evals | OpenAI Developers"
type: web
url: "https://developers.openai.com/blog/eval-skills"
fetched: "2026-07-02T20:21:39Z"
---

@layer theme, base, components, utilities;
Testing Agent Skills Systematically with Evals | OpenAI Developers
.blog-prose-content :where(h2):not(:where([class~=not-prose],[class~=not-prose] \*)){font-size:var(--font-heading-xl-size);font-weight:var(--font-heading-xl-weight);letter-spacing:var(--font-heading-xl-tracking);line-height:var(--font-heading-xl-line-height)}.blog-prose-content :where(h3):not(:where([class~=not-prose],[class~=not-prose] \*)){font-size:var(--font-heading-lg-size);font-weight:var(--font-heading-lg-weight);letter-spacing:var(--font-heading-lg-tracking);line-height:var(--font-heading-lg-line-height)}
.page-copy-action:where(.astro-y3m22efp){display:inline-flex;min-height:26px;align-items:center;justify-content:center;gap:6px;border:1px solid var(--border-primary-outline, rgb(209 213 219));border-radius:8px;background:var(--surface-primary, #fff);padding:5px 10px;color:var(--text-primary, #202123);font-size:12px;font-weight:500;line-height:1;white-space:nowrap;transition:border-color .12s ease,background-color .12s ease,color .12s ease,opacity .12s ease}.page-copy-action:where(.astro-y3m22efp):hover:not(:disabled){background:var(--surface-primary-hover, #f7f7f8)}.page-copy-action:where(.astro-y3m22efp):focus-visible{outline:2px solid var(--border-primary, #111);outline-offset:2px}.page-copy-action:where(.astro-y3m22efp):disabled{cursor:progress;opacity:.7}.page-copy-action--cta:where(.astro-y3m22efp){min-height:42px;gap:8px;border-radius:9999px;padding:10px 18px;font-size:14px}.page-copy-action\_\_icon:where(.astro-y3m22efp){display:inline-flex;width:14px;height:14px;align-items:center;justify-content:center}.page-copy-action\_\_icon:where(.astro-y3m22efp) svg{width:14px;height:14px}.page-copy-action\_\_icon--check:where(.astro-y3m22efp),.page-copy-action:where(.astro-y3m22efp)[data-copied=true] .page-copy-action\_\_icon--copy:where(.astro-y3m22efp){display:none}.page-copy-action:where(.astro-y3m22efp)[data-copied=true] .page-copy-action\_\_icon--check:where(.astro-y3m22efp){display:inline-flex}
  

[![OpenAI Developers](/OpenAI_Developers.svg)](/)   

[Home](/)

[API](/api) 

[Docs

Guides and concepts for the OpenAI API](/api/docs)[API reference

Endpoints, parameters, and responses](/api/reference/overview)

[Codex](/codex) 

[Docs

Guides, concepts, and product docs for Codex](/codex)[Use cases

Example workflows and tasks teams hand to Codex](/codex/use-cases)

[ChatGPT](/chatgpt) 

[Apps SDK

Build apps to extend ChatGPT](/apps-sdk)[Workspace Agents

Trigger published ChatGPT workspace agents](/workspace-agents)[Commerce

Build commerce flows in ChatGPT](/commerce)[Ads

Publish and measure ads in ChatGPT](/ads)

[Resources](/learn) 

[Showcase

Demo apps to get inspired](/showcase)[Blog

Learnings and experiences from developers](/blog)[Cookbook

Notebook examples for building with OpenAI models](/cookbook)[Learn

Docs, videos, and demo apps for building with OpenAI](/learn)[Community

Programs, meetups, and support for builders](/community)

 

Start searching  

[API Dashboard](https://platform.openai.com/login)

## Search the blog

astro-island,astro-slot,astro-static-slot{display:contents}(()=>{var e=async t=>{await(await t())()};(self.Astro||(self.Astro={})).load=e;window.dispatchEvent(new Event("astro:load"));})();(()=>{var A=Object.defineProperty;var g=(i,o,a)=>o in i?A(i,o,{enumerable:!0,configurable:!0,writable:!0,value:a}):i[o]=a;var d=(i,o,a)=>g(i,typeof o!="symbol"?o+"":o,a);{let i={0:t=>m(t),1:t=>a(t),2:t=>new RegExp(t),3:t=>new Date(t),4:t=>new Map(a(t)),5:t=>new Set(a(t)),6:t=>BigInt(t),7:t=>new URL(t),8:t=>new Uint8Array(t),9:t=>new Uint16Array(t),10:t=>new Uint32Array(t),11:t=>Number.POSITIVE\_INFINITY\*t},o=t=>{let[l,e]=t;return l in i?i[l](e):void 0},a=t=>t.map(o),m=t=>typeof t!="object"||t===null?t:Object.fromEntries(Object.entries(t).map(([l,e])=>[l,o(e)]));class y extends HTMLElement{constructor(){super(...arguments);d(this,"Component");d(this,"hydrator");d(this,"hydrate",async()=>{var b;if(!this.hydrator||!this.isConnected)return;let e=(b=this.parentElement)==null?void 0:b.closest("astro-island[ssr]");if(e){e.addEventListener("astro:hydrate",this.hydrate,{once:!0});return}let c=this.querySelectorAll("astro-slot"),n={},h=this.querySelectorAll("template[data-astro-template]");for(let r of h){let s=r.closest(this.tagName);s!=null&&s.isSameNode(this)&&(n[r.getAttribute("data-astro-template")||"default"]=r.innerHTML,r.remove())}for(let r of c){let s=r.closest(this.tagName);s!=null&&s.isSameNode(this)&&(n[r.getAttribute("name")||"default"]=r.innerHTML)}let p;try{p=this.hasAttribute("props")?m(JSON.parse(this.getAttribute("props"))):{}}catch(r){let s=this.getAttribute("component-url")||"<unknown>",v=this.getAttribute("component-export");throw v&&(s+=` (export ${v})`),console.error(`[hydrate] Error parsing props for component ${s}`,this.getAttribute("props"),r),r}let u;await this.hydrator(this)(this.Component,p,n,{client:this.getAttribute("client")}),this.removeAttribute("ssr"),this.dispatchEvent(new CustomEvent("astro:hydrate"))});d(this,"unmount",()=>{this.isConnected||this.dispatchEvent(new CustomEvent("astro:unmount"))})}disconnectedCallback(){document.removeEventListener("astro:after-swap",this.unmount),document.addEventListener("astro:after-swap",this.unmount,{once:!0})}connectedCallback(){if(!this.hasAttribute("await-children")||document.readyState==="interactive"||document.readyState==="complete")this.childrenConnectedCallback();else{let e=()=>{document.removeEventListener("DOMContentLoaded",e),c.disconnect(),this.childrenConnectedCallback()},c=new MutationObserver(()=>{var n;((n=this.lastChild)==null?void 0:n.nodeType)===Node.COMMENT\_NODE&&this.lastChild.nodeValue==="astro:end"&&(this.lastChild.remove(),e())});c.observe(this,{childList:!0}),document.addEventListener("DOMContentLoaded",e)}}async childrenConnectedCallback(){let e=this.getAttribute("before-hydration-url");e&&await import(e),this.start()}async start(){let e=JSON.parse(this.getAttribute("opts")),c=this.getAttribute("client");if(Astro[c]===void 0){window.addEventListener(`astro:${c}`,()=>this.start(),{once:!0});return}try{await Astro[c](async()=>{let n=this.getAttribute("renderer-url"),[h,{default:p}]=await Promise.all([import(this.getAttribute("component-url")),n?import(n):()=>()=>{}]),u=this.getAttribute("component-export")||"default";if(!u.includes("."))this.Component=h[u];else{this.Component=h;for(let f of u.split("."))this.Component=this.Component[f]}return this.hydrator=p,this.hydrate},e,this)}catch(n){console.error(`[astro-island] Error hydrating ${this.getAttribute("component-url")}`,n)}}attributeChangedCallback(){this.hydrate()}}d(y,"observedAttributes",["props"]),customElements.get("astro-island")||customElements.define("astro-island",y)}})();

Search docs

### Suggested

responses createreasoning\_effortrealtimeprompt caching

Primary navigation

API  API Reference  Codex  ChatGPT  Resources

Search docs

### Suggested

responses createreasoning\_effortrealtimeprompt caching

### Get started

- [Overview](/api/docs)
- [Quickstart](/api/docs/quickstart)
- [Models](/api/docs/models)
- [Pricing](/api/docs/pricing)
- [SDKs and CLI](/api/docs/libraries)   
  - [OpenAI SDK](/api/docs/libraries)
  - [Agents SDK](/api/docs/guides/agents)
  - [OpenAI CLI](/api/docs/libraries/openai-cli)
- [Latest: GPT-5.5](/api/docs/guides/latest-model)
- [Prompt guidance](/api/docs/guides/prompt-guidance)

### Core concepts

- [Text generation](/api/docs/guides/text)
- [Code generation](/api/docs/guides/code-generation)
- [Images and vision](/api/docs/guides/images-vision)
- [Audio and speech](/api/docs/guides/audio)
- [Structured output](/api/docs/guides/structured-outputs)
- [Function calling](/api/docs/guides/function-calling)
- [Responses API](/api/docs/guides/migrate-to-responses)
- [Using tools](/api/docs/guides/tools)

### Agents SDK

- [Overview](/api/docs/guides/agents)
- [Quickstart](/api/docs/guides/agents/quickstart)
- [Agent definitions](/api/docs/guides/agents/define-agents)
- [Models and providers](/api/docs/guides/agents/models)
- [Running agents](/api/docs/guides/agents/running-agents)
- [Sandbox agents](/api/docs/guides/agents/sandboxes)
- [Orchestration](/api/docs/guides/agents/orchestration)
- [Guardrails](/api/docs/guides/agents/guardrails-approvals)
- [Results and state](/api/docs/guides/agents/results)
- [Integrations and observability](/api/docs/guides/agents/integrations-observability)
- [Evaluate agent workflows](/api/docs/guides/agent-evals)
- [Voice agents](/api/docs/guides/voice-agents)
- ChatKit  
  - [Overview](/api/docs/guides/chatkit)
  - [Customize](/api/docs/guides/chatkit-themes)
  - [Widgets](/api/docs/guides/chatkit-widgets)
  - [Actions](/api/docs/guides/chatkit-actions)
  - [Advanced integrations](/api/docs/guides/custom-chatkit)

### Tools

- [Web search](/api/docs/guides/tools-web-search)
- [MCP and Connectors](/api/docs/guides/tools-connectors-mcp)   
  - [Secure MCP Tunnel](/api/docs/guides/secure-mcp-tunnels)
- [Skills](/api/docs/guides/tools-skills)
- [Shell](/api/docs/guides/tools-shell)
- [Computer use](/api/docs/guides/tools-computer-use)
- File search and retrieval  
  - [File search](/api/docs/guides/tools-file-search)
  - [Retrieval](/api/docs/guides/retrieval)
- [Tool search](/api/docs/guides/tools-tool-search)
- More tools  
  - [Apply Patch](/api/docs/guides/tools-apply-patch)
  - [Local shell](/api/docs/guides/tools-local-shell)
  - [Image generation](/api/docs/guides/tools-image-generation)
  - [Code interpreter](/api/docs/guides/tools-code-interpreter)

### Run and scale

- [Conversation state](/api/docs/guides/conversation-state)
- [Background mode](/api/docs/guides/background)
- [Streaming](/api/docs/guides/streaming-responses)
- [WebSocket mode](/api/docs/guides/websocket-mode)
- [Webhooks](/api/docs/guides/webhooks)
- [File inputs](/api/docs/guides/file-inputs)
- Context management  
  - [Compaction](/api/docs/guides/compaction)
  - [Counting tokens](/api/docs/guides/token-counting)
  - [Prompt caching](/api/docs/guides/prompt-caching)
- Prompting  
  - [Overview](/api/docs/guides/prompting)
  - [Prompt engineering](/api/docs/guides/prompt-engineering)
  - [Citation formatting](/api/docs/guides/citation-formatting)
  - [Migration guide](/api/docs/guides/prompting/migrate-from-prompt-object)
- Reasoning  
  - [Reasoning models](/api/docs/guides/reasoning)
  - [Reasoning best practices](/api/docs/guides/reasoning-best-practices)

### Evaluation

- [Red teaming](/api/docs/guides/red-teaming)

### Realtime and audio

- [Overview](/api/docs/guides/realtime)
- [Voice agents](/api/docs/guides/voice-agents)
- [Live translation](/api/docs/guides/realtime-translation)
- Transcription  
  - [Realtime transcription](/api/docs/guides/realtime-transcription)
  - [Speech to text](/api/docs/guides/speech-to-text)
- [Speech generation](/api/docs/guides/text-to-speech)
- [Realtime prompting guide](/api/docs/guides/realtime-models-prompting)
- Connection methods  
  - [WebRTC](/api/docs/guides/realtime-webrtc)
  - [WebSocket](/api/docs/guides/realtime-websocket)
  - [SIP](/api/docs/guides/realtime-sip)
- Realtime sessions  
  - [Managing conversations](/api/docs/guides/realtime-conversations)
  - [Voice activity detection](/api/docs/guides/realtime-vad)
  - [Realtime with tools](/api/docs/guides/realtime-mcp)
  - [Webhooks and server-side controls](/api/docs/guides/realtime-server-controls)
  - [Managing costs](/api/docs/guides/realtime-costs)

### Specialized models

- [Image generation](/api/docs/guides/image-generation)
- [Video generation](/api/docs/guides/video-generation)
- [Deep research](/api/docs/guides/deep-research)
- [Embeddings](/api/docs/guides/embeddings)
- [Moderation](/api/docs/guides/moderation)

### Going live

- [Production best practices](/api/docs/guides/production-best-practices)
- [Workload identity federation](/api/docs/guides/workload-identity-federation)   
  - [Overview](/api/docs/guides/workload-identity-federation)
  - [Kubernetes](/api/docs/guides/workload-identity-federation/kubernetes)
  - [AWS](/api/docs/guides/workload-identity-federation/aws)
  - [Microsoft Azure](/api/docs/guides/workload-identity-federation/microsoft-azure)
  - [Google Cloud](/api/docs/guides/workload-identity-federation/google-cloud)
  - [GitHub Actions](/api/docs/guides/workload-identity-federation/github-actions)
  - [SPIFFE](/api/docs/guides/workload-identity-federation/spiffe)
- [Deployment checklist](/api/docs/guides/deployment-checklist)
- [Amazon Bedrock](/api/docs/guides/amazon-bedrock)
- Latency optimization  
  - [Overview](/api/docs/guides/latency-optimization)
  - [Predicted Outputs](/api/docs/guides/predicted-outputs)
  - [Priority processing](/api/docs/guides/priority-processing)
- Cost optimization  
  - [Overview](/api/docs/guides/cost-optimization)
  - [Batch](/api/docs/guides/batch)
  - [Flex processing](/api/docs/guides/flex-processing)
- [Accuracy optimization](/api/docs/guides/optimizing-llm-accuracy)
- Safety  
  - [Safety best practices](/api/docs/guides/safety-best-practices)
  - [Safety checks](/api/docs/guides/safety-checks)
  - [Cybersecurity checks](/api/docs/guides/safety-checks/cybersecurity)
  - [Under 18 API Guidance](/api/docs/guides/safety-checks/under-18-api-guidance)

### Legacy APIs

- Agent Builder  
  - [Overview](/api/docs/guides/agent-builder)
  - [Migration guide](/api/docs/guides/agent-builder/migrate-from-agent-builder)
  - [Node reference](/api/docs/guides/node-reference)
  - [Safety in building agents](/api/docs/guides/agent-builder-safety)
- Evals  
  - [Getting started](/api/docs/guides/evaluation-getting-started)
  - [Working with evals](/api/docs/guides/evals)
  - [Prompt optimizer](/api/docs/guides/prompt-optimizer)
  - [External models](/api/docs/guides/external-models)
  - [Best practices](/api/docs/guides/evaluation-best-practices)
  - [Graders](/api/docs/guides/graders)
- Fine-tuning  
  - [Optimization cycle](/api/docs/guides/model-optimization)
  - [Supervised fine-tuning](/api/docs/guides/supervised-fine-tuning)
  - [Vision fine-tuning](/api/docs/guides/vision-fine-tuning)
  - [Direct preference optimization](/api/docs/guides/direct-preference-optimization)
  - [Reinforcement fine-tuning](/api/docs/guides/reinforcement-fine-tuning)
  - [RFT use cases](/api/docs/guides/rft-use-cases)
  - [Best practices](/api/docs/guides/fine-tuning-best-practices)
- Assistants API  
  - [Migration guide](/api/docs/assistants/migration)
  - [Deep dive](/api/docs/assistants/deep-dive)
  - [Tools](/api/docs/assistants/tools)

### Resources

- [Terms and policies](https://openai.com/policies)
- [Changelog](/api/docs/changelog)
- [Your data](/api/docs/guides/your-data)
- [Permissions](/api/docs/guides/rbac)
- [Rate limits](/api/docs/guides/rate-limits)
- [IP egress ranges](/api/docs/guides/ip-addresses)
- [Admin APIs](/api/docs/guides/admin-apis)
- [Deprecations](/api/docs/deprecations)
- [MCP for deep research](/api/docs/mcp)
- [Developer mode](/api/docs/guides/developer-mode)
- ChatGPT Actions  
  - [Introduction](/api/docs/actions/introduction)
  - [Getting started](/api/docs/actions/getting-started)
  - [Actions library](/api/docs/actions/actions-library)
  - [Authentication](/api/docs/actions/authentication)
  - [Production](/api/docs/actions/production)
  - [Data retrieval](/api/docs/actions/data-retrieval)
  - [Sending files](/api/docs/actions/sending-files)

Docs  Use cases

### Getting Started

- [Overview](/codex)
- [Quickstart](/codex/quickstart)
- [Explore use cases](/codex/use-cases)
- [Import to Codex](/codex/import)
- [Pricing](/codex/pricing)
- Concepts  
  - [Prompting](/codex/prompting)
  - [Customization](/codex/concepts/customization)
  - [Memories](/codex/memories)   
    - [Chronicle](/codex/memories/chronicle)
  - [Sandboxing](/codex/concepts/sandboxing)   
    - [Auto-review](/codex/concepts/sandboxing/auto-review)
  - [Subagents](/codex/concepts/subagents)
  - [Workflows](/codex/workflows)
  - [Models](/codex/models)
  - [Cyber Safety](/codex/concepts/cyber-safety)
  - [Glossary](/codex/glossary)

### Using Codex

- App  
  - [Overview](/codex/app)
  - [Features](/codex/app/features)
  - [Settings](/codex/app/settings)
  - [Review](/codex/app/review)
  - [Automations](/codex/app/automations)
  - [Worktrees](/codex/app/worktrees)
  - [Local Environments](/codex/app/local-environments)
  - [In-app browser](/codex/app/browser)
  - [Chrome extension](/codex/app/chrome-extension)
  - [Computer Use](/codex/app/computer-use)
  - [Appshots](/codex/appshots)
  - [Commands](/codex/app/commands)
  - [Windows](/codex/app/windows)
  - [Troubleshooting](/codex/app/troubleshooting)
- IDE Extension  
  - [Overview](/codex/ide)
  - [Features](/codex/ide/features)
  - [Settings](/codex/ide/settings)
  - [IDE Commands](/codex/ide/commands)
  - [Slash commands](/codex/ide/slash-commands)
- CLI  
  - [Overview](/codex/cli)
  - [Features](/codex/cli/features)
  - [Command Line Options](/codex/cli/reference)
  - [Slash commands](/codex/cli/slash-commands)
- Web  
  - [Overview](/codex/cloud)
  - [Environments](/codex/cloud/environments)
  - [Internet Access](/codex/cloud/internet-access)
- Integrations  
  - [GitHub](/codex/integrations/github)
  - [Slack](/codex/integrations/slack)
  - [Linear](/codex/integrations/linear)
- Codex Security  
  - [Overview](/codex/security)
  - Codex Security plugin  
    - [Quickstart](/codex/security/plugin)
    - [Run a security scan](/codex/security/plugin/scans)
    - [Run a deep scan](/codex/security/plugin/deep-scans)
    - [Review code changes](/codex/security/plugin/code-changes)
    - [Triage a backlog](/codex/security/plugin/triage-backlog)
    - [Fix findings](/codex/security/plugin/fix-findings)
    - [Export and track findings](/codex/security/plugin/export-findings)
    - [Changelog](/codex/security/plugin/changelog)
  - Codex Security cloud  
    - [Setup](/codex/security/setup)
    - [Improving the threat model](/codex/security/threat-model)
  - [FAQ](/codex/security/faq)

### Configuration

- Config File  
  - [Config Basics](/codex/config-basic)
  - [Advanced Config](/codex/config-advanced)
  - [Config Reference](/codex/config-reference)
  - [Environment Variables](/codex/environment-variables)
  - [Sample Config](/codex/config-sample)
- [Permissions](/codex/permissions)
- [Speed](/codex/speed)
- [Rules](/codex/rules)
- [Hooks](/codex/hooks)
- [AGENTS.md](/codex/guides/agents-md)
- [MCP](/codex/mcp)
- Plugins  
  - [Overview](/codex/plugins)
  - [Build plugins](/codex/plugins/build)
- [Sites](/codex/sites)
- Skills  
  - [Overview](/codex/skills)
  - [Record & Replay](/codex/record-and-replay)
- [Subagents](/codex/subagents)

### Administration

- Authentication  
  - [Overview](/codex/auth)
  - [Access tokens](/codex/enterprise/access-tokens)
- [Agent approvals & security](/codex/agent-approvals-security)
- [Remote connections](/codex/remote-connections)
- Deployment  
  - [Amazon Bedrock](/codex/amazon-bedrock)
- Enterprise  
  - [Admin Setup](/codex/enterprise/admin-setup)
  - [Governance](/codex/enterprise/governance)
  - [Managed configuration](/codex/enterprise/managed-configuration)
- [Windows](/codex/windows)

### Automation

- [Non-interactive Mode](/codex/noninteractive)
- [Codex SDK](/codex/sdk)
- [App Server](/codex/app-server)
- [MCP Server](/codex/guides/agents-sdk)
- [GitHub Action](/codex/github-action)

### Learn

- [Best practices](/codex/learn/best-practices)
- [Videos](/codex/videos)
- [Community](/community)
- Blog  
  - [Mastering Codex Remote for engineering](/blog/mastering-codex-remote-for-engineering)
  - [Using skills to accelerate OSS maintenance](/blog/skills-agents-sdk)
  - [View all](/blog/topic/codex)
- Cookbooks  
  - [Build an Agent Improvement Loop with Traces, Evals, and Codex](/cookbook/examples/agents_sdk/agent_improvement_loop)
  - [Build iterative repair loops with Codex](/cookbook/examples/codex/build_iterative_repair_loops_with_codex)
  - [View all](/cookbook/topic/codex)
- [Building AI Teams](/codex/guides/build-ai-native-engineering-team)

### Releases

- [Changelog](/codex/changelog)
- [Feature Maturity](/codex/feature-maturity)
- [Open Source](/codex/open-source)

- [Home](/codex/use-cases)
- [Collections](/codex/use-cases/collections)

Apps SDK  Workspace Agents  Commerce  Ads

- [Home](/apps-sdk)
- [Quickstart](/apps-sdk/quickstart)

### Core Concepts

- [MCP Apps in ChatGPT](/apps-sdk/mcp-apps-in-chatgpt)
- [MCP Server](/apps-sdk/concepts/mcp-server)
- [UX principles](/apps-sdk/concepts/ux-principles)
- [UI guidelines](/apps-sdk/concepts/ui-guidelines)

### Plan

- [Research use cases](/apps-sdk/plan/use-case)
- [Define tools](/apps-sdk/plan/tools)
- [Design components](/apps-sdk/plan/components)

### Build

- [Set up your server](/apps-sdk/build/mcp-server)
- [Build your ChatGPT UI](/apps-sdk/build/chatgpt-ui)
- [Authenticate users](/apps-sdk/build/auth)
- [Manage state](/apps-sdk/build/state-management)
- [Monetize your app](/apps-sdk/build/monetization)
- [Examples](/apps-sdk/build/examples)

### Deploy

- [Deploy your app](/apps-sdk/deploy)
- [Connect from ChatGPT](/apps-sdk/deploy/connect-chatgpt)
- [Test your integration](/apps-sdk/deploy/testing)
- [Submit your app](/apps-sdk/deploy/submission)

### Conversion apps

- [Restaurant reservation spec](/apps-sdk/guides/restaurant-reservation-conversion-spec)
- [Product checkout spec](/apps-sdk/guides/product-checkout-conversion-spec)

### Guides

- [Optimize Metadata](/apps-sdk/guides/optimize-metadata)
- [Security & Privacy](/apps-sdk/guides/security-privacy)
- [Troubleshooting](/apps-sdk/deploy/troubleshooting)

### Resources

- [Changelog](/apps-sdk/changelog)
- [App submission guidelines](/apps-sdk/app-submission-guidelines)
- [Reference](/apps-sdk/reference)

- [Home](/workspace-agents)

### Get started

- [Trigger workspace agent runs](/workspace-agents/trigger-runs)
- [Authenticate with Workspace Agent access tokens](/workspace-agents/authentication)

- [Home](/commerce)

### Guides

- [Get started](/commerce/guides/get-started)
- [Best practices](/commerce/guides/best-practices)

### File Upload

- [Overview](/commerce/specs/file-upload/overview)
- [Products](/commerce/specs/file-upload/products)

### API

- [Overview](/commerce/specs/api/overview)
- [Feeds](/commerce/specs/api/feeds)
- [Products](/commerce/specs/api/products)
- [Promotions](/commerce/specs/api/promotions)

- [Ads Overview](/ads)

### Measurement

- [JavaScript Pixel](/ads/measurement-pixel)
- [Image tag](/ads/image-tag)
- [Conversions API](/ads/conversions-api)
- [Supported events](/ads/supported-events)

### Advertiser API

- [Overview](/ads/api-overview)
- [Quickstart](/ads/api-quickstart)
- [Product feeds](/ads/product-feeds)
- [Campaign Targeting](/ads/campaign-targeting)

### API Reference

- [Authentication](/ads/api-reference/authentication)
- [Campaigns](/ads/api-reference/campaigns)
- [Ad Groups](/ads/api-reference/ad-groups)
- [Ads](/ads/api-reference/ads)
- [Ad Account](/ads/api-reference/ad-account)
- [Insights](/ads/api-reference/insights)
- [Files](/ads/api-reference/files)

Showcase  Blog  Cookbook  Learn  Community

- [Home](/showcase)
- [API examples](/showcase/api-examples)
- [Sites](/showcase/sites)

- [All posts](/blog)

### Recent

- [Making private MCP servers reachable without making them public](/blog/connect-private-mcp-servers-to-openai-products)
- [Mastering Codex Remote for engineering](/blog/mastering-codex-remote-for-engineering)
- [How Perplexity Brought Voice Search to Millions Using the Realtime API](/blog/realtime-perplexity-computer)
- [Designing delightful frontends with GPT-5.4](/blog/designing-delightful-frontends-with-gpt-5-4)
- [From prompts to products: One year of Responses](/blog/one-year-of-responses)

### Topics

- [General](/blog/topic/general)
- [API](/blog/topic/api)
- [Apps SDK](/blog/topic/apps-sdk)
- [Audio](/blog/topic/audio)
- [Codex](/blog/topic/codex)

- [Home](/cookbook)

### Topics

- [Agents](/cookbook/topic/agents)
- [Evals](/cookbook/topic/evals)
- [Multimodal](/cookbook/topic/multimodal)
- [Text](/cookbook/topic/text)
- [Guardrails](/cookbook/topic/guardrails)
- [Optimization](/cookbook/topic/optimization)
- [ChatGPT](/cookbook/topic/chatgpt)
- [Codex](/cookbook/topic/codex)
- [gpt-oss](/cookbook/topic/gpt-oss)

### Contribute

- [Cookbook on GitHub](https://github.com/openai/openai-cookbook)

- [Home](/learn)
- [OpenAI Developers plugin](/learn/developers-codex-plugin)
- [Docs MCP](/learn/docs-mcp)

### Categories

- [Demo apps](/learn/code)
- [Videos](/learn/videos)

### Topics

- [Agents](/learn/agents)
- [Audio & Voice](/learn/audio)
- [Computer Use](/learn/cua)
- [Codex](/learn/codex)
- [Evals](/learn/evals)
- [gpt-oss](/learn/gpt-oss)
- [Fine-tuning](/learn/fine-tuning)
- [Image generation](/learn/imagegen)
- [Scaling](/learn/scaling)
- [Tools](/learn/tools)
- [Video generation](/learn/videogen)

- [Community](/community)

### Programs

- [Codex Ambassadors](/community/codex-ambassadors)
- [Codex for Students](/community/students)
- [Codex for Open Source](/community/codex-for-oss)
- [OpenAI for Startups](https://openai.com/business/why-openai/startups/)

### Events

- [Meetups](/community/meetups)

### Spaces

- [Developer Forum](https://community.openai.com/)
- [Discord](https://discord.com/invite/openai)
- [Reddit](https://www.reddit.com/r/OpenAI/)
- [X](https://x.com/OpenAIDevs)

[API Dashboard](https://platform.openai.com/login)

const MOBILE\_NAV\_PERSIST\_KEY = "mobile-nav:restore-open";
const readPersistedMobileNavOpen = () => {
try {
return sessionStorage.getItem(MOBILE\_NAV\_PERSIST\_KEY) === "true";
} catch {
return false;
}
};
const setPersistedMobileNavOpen = (isOpen) => {
try {
if (isOpen) {
sessionStorage.setItem(MOBILE\_NAV\_PERSIST\_KEY, "true");
} else {
sessionStorage.removeItem(MOBILE\_NAV\_PERSIST\_KEY);
}
} catch {}
};
function initializeMobileNavigation() {
const drawer = document.getElementById("drawer");
const drawerButton = document.getElementById("header-drawer-button");
if (
!drawer ||
!drawerButton ||
drawer.dataset.mobileNavInitialized === "true"
) {
return;
}
const navTabElements = Array.from(
drawer.querySelectorAll("[data-mobile-nav-tab]")
);
const defaultSearchPlaceholder =
drawer.dataset.defaultSearchPlaceholder || "Search the site";
const defaultSearchScope = drawer.dataset.defaultSearchScope || "";
const headerSearchOverlay = document.getElementById(
"header-search-overlay"
);
const navLinkElements = Array.from(
drawer.querySelectorAll("[data-mobile-nav-link]")
);
const tabPanels = Array.from(
drawer.querySelectorAll("[data-mobile-nav-content]")
);
const isStarlightApiReferenceRoute =
window.location.pathname === "/api/reference" ||
window.location.pathname.startsWith("/api/reference/");
const shouldRestoreDrawerOpen =
matchMedia("(max-width: 50rem)").matches &&
!isStarlightApiReferenceRoute &&
readPersistedMobileNavOpen();
let activeTabId =
drawer.dataset.defaultTabId ||
navTabElements.find((tab) => tab.dataset.selected === "true")?.dataset
.tabId ||
null;
const updateSelectedOption = (tabId) => {
let selectedLabel = "";
let selectedPlaceholder = "";
let selectedScope = "";
navTabElements.forEach((tab) => {
const isSelected = tab.dataset.tabId === tabId;
tab.dataset.selected = isSelected ? "true" : "false";
tab.setAttribute("aria-selected", isSelected ? "true" : "false");
if (isSelected && !selectedLabel) {
selectedLabel = tab.dataset.label || tab.textContent?.trim() || "";
}
if (isSelected && !selectedPlaceholder) {
selectedPlaceholder = tab.dataset.searchPlaceholder || "";
}
if (isSelected && !selectedScope) {
selectedScope = tab.dataset.searchScope || "";
}
});
if (!selectedLabel && navTabElements[0]) {
selectedLabel =
navTabElements[0].dataset.label ||
navTabElements[0].textContent?.trim() ||
"";
}
if (!selectedPlaceholder && navTabElements[0]) {
selectedPlaceholder = navTabElements[0].dataset.searchPlaceholder || "";
}
if (!selectedScope && navTabElements[0]) {
selectedScope = navTabElements[0].dataset.searchScope || "";
}
const nextPlaceholder = selectedPlaceholder || defaultSearchPlaceholder;
const nextScope = selectedScope || defaultSearchScope;
const updatePlaceholder = (container) => {
if (!container) return;
const input = container.querySelector("[data-site-search-input]");
if (input instanceof HTMLInputElement) {
input.placeholder = nextPlaceholder;
}
};
const updateScope = (container) => {
if (!container) return;
const target = container.querySelector("[data-site-search-root]");
if (!target) return;
target.setAttribute("data-scope", nextScope);
target.dispatchEvent(new CustomEvent("site-search:update"));
};
updatePlaceholder(drawer);
updatePlaceholder(headerSearchOverlay);
updateScope(drawer);
updateScope(headerSearchOverlay);
};
const activeVariantByTabId = new Map();
const getTabLabel = (tabId) => {
return (
navTabElements.find((tab) => tab.dataset.tabId === tabId)?.dataset
.label || ""
);
};
const updatePanelBreadcrumb = (panel, tabId, contextLabel) => {
const breadcrumb = panel.querySelector("[data-mobile-breadcrumb]");
const parent = panel.querySelector("[data-mobile-breadcrumb-parent]");
const childWrapper = panel.querySelector(
"[data-mobile-breadcrumb-child-wrapper]"
);
const child = panel.querySelector("[data-mobile-breadcrumb-child]");
const contextOptions = panel.querySelector(
"[data-mobile-context-options]"
);
if (contextOptions) {
contextOptions.dataset.contextActive = contextLabel ? "true" : "false";
}
if (!breadcrumb || !parent || !childWrapper || !child) {
return;
}
const tabLabel = getTabLabel(tabId);
parent.textContent = tabLabel;
if (!contextLabel) {
breadcrumb.setAttribute("hidden", "true");
childWrapper.setAttribute("hidden", "true");
child.textContent = "";
return;
}
breadcrumb.removeAttribute("hidden");
childWrapper.removeAttribute("hidden");
child.textContent = contextLabel;
};
const selectVariantForPanel = (panel, tabId, variantId) => {
if (!variantId) {
updatePanelBreadcrumb(panel, tabId, "");
return;
}
const contextOptions = Array.from(
panel.querySelectorAll("[data-mobile-context-option]")
);
let selectedContextLabel = "";
contextOptions.forEach((option) => {
const isSelected = option.dataset.contextId === variantId;
option.dataset.selected = isSelected ? "true" : "false";
if (isSelected) {
selectedContextLabel = option.dataset.contextLabel || "";
}
});
const variantSections = Array.from(
panel.querySelectorAll("[data-mobile-nav-variant-content]")
);
variantSections.forEach((section) => {
const isSelected = section.dataset.variantId === variantId;
if (isSelected) {
section.removeAttribute("hidden");
} else {
section.setAttribute("hidden", "true");
}
});
updatePanelBreadcrumb(panel, tabId, selectedContextLabel);
activeVariantByTabId.set(tabId, variantId);
};
const activateTab = (tabId) => {
if (!tabId) return;
activeTabId = tabId;
updateSelectedOption(tabId);
tabPanels.forEach((panel) => {
const panelTabId = panel.getAttribute("data-tab-id");
const isActive = panelTabId === tabId;
if (isActive) {
panel.removeAttribute("hidden");
const defaultVariantId = panel.getAttribute(
"data-default-variant-id"
);
const nextVariantId =
activeVariantByTabId.get(tabId) ||
defaultVariantId ||
panel.querySelector("[data-mobile-nav-variant-content]")?.dataset
.variantId ||
"";
selectVariantForPanel(panel, tabId, nextVariantId);
} else {
panel.setAttribute("hidden", "true");
}
});
};
const closeDrawer = () => {
drawer.classList.remove("open");
drawerButton.classList.remove("open");
drawerButton.setAttribute("aria-expanded", "false");
setPersistedMobileNavOpen(false);
};
const openDrawer = () => {
drawer.classList.add("open");
drawerButton.classList.add("open");
drawerButton.setAttribute("aria-expanded", "true");
if (activeTabId) {
activateTab(activeTabId);
}
};
const toggleDrawer = () => {
if (drawer.classList.contains("open")) {
closeDrawer();
} else {
openDrawer();
}
};
const handleTabSelection = (tab) => {
const hasNav = tab.dataset.hasNav === "true";
const href = tab.dataset.href;
const tabId = tab.dataset.tabId;
if (!tabId) {
return;
}
if (!hasNav && href) {
setPersistedMobileNavOpen(true);
window.location.href = href;
return;
}
activateTab(tabId);
};
drawerButton.addEventListener("click", toggleDrawer);
navTabElements.forEach((tab) => {
tab.addEventListener("click", () => {
handleTabSelection(tab);
});
tab.addEventListener("keydown", (event) => {
if (!navTabElements.length) return;
const currentIndex = navTabElements.indexOf(tab);
if (event.key === "ArrowRight") {
event.preventDefault();
const nextIndex = (currentIndex + 1) % navTabElements.length;
navTabElements[nextIndex]?.focus();
} else if (event.key === "ArrowLeft") {
event.preventDefault();
const prevIndex =
(currentIndex - 1 + navTabElements.length) % navTabElements.length;
navTabElements[prevIndex]?.focus();
} else if (event.key === "Home") {
event.preventDefault();
navTabElements[0]?.focus();
} else if (event.key === "End") {
event.preventDefault();
navTabElements[navTabElements.length - 1]?.focus();
} else if (
event.key === "Enter" ||
event.key === " " ||
event.key === "Space" ||
event.key === "Spacebar"
) {
event.preventDefault();
handleTabSelection(tab);
} else if (event.key === "Escape") {
event.preventDefault();
closeDrawer();
drawerButton.focus();
}
});
});
tabPanels.forEach((panel) => {
const tabId = panel.getAttribute("data-tab-id") || "";
const contextOptions = Array.from(
panel.querySelectorAll("[data-mobile-context-option]")
);
contextOptions.forEach((option) => {
option.addEventListener("click", () => {
const contextHref = option.dataset.contextHref;
if (
contextHref &&
contextHref.startsWith("/api/reference") &&
tabId
) {
closeDrawer();
window.location.href = contextHref;
return;
}
const variantId = option.dataset.contextId;
if (!variantId || !tabId) {
return;
}
selectVariantForPanel(panel, tabId, variantId);
});
});
});
navLinkElements.forEach((link) => {
link.addEventListener("click", () => {
closeDrawer();
});
});
const mobileSearch = drawer.querySelector("[data-mobile-search]");
mobileSearch?.addEventListener("click", (event) => {
const target = event.target;
if (target instanceof Element) {
const anchor = target.closest("a[href]");
if (anchor) {
closeDrawer();
}
}
});
mobileSearch?.addEventListener("focusin", (event) => {
const target = event.target;
if (!(target instanceof HTMLInputElement) || target.type !== "text") {
return;
}
closeDrawer();
window.requestAnimationFrame(() => {
if (document.activeElement === target) {
target.blur();
}
document.dispatchEvent(
new CustomEvent("header:open-search", {
detail: {
trigger: target,
variant: "mobile",
},
})
);
});
});
drawer.addEventListener("keydown", (event) => {
if (event.key === "Escape") {
closeDrawer();
drawerButton.focus();
}
});
drawer.dataset.mobileNavInitialized = "true";
if (activeTabId) {
activateTab(activeTabId);
}
if (shouldRestoreDrawerOpen) {
openDrawer();
setPersistedMobileNavOpen(false);
}
}
function initializeHeaderSearch() {
const overlay = document.getElementById("header-search-overlay");
if (!overlay) {
return;
}
const getSearchButtons = () =>
Array.from(document.querySelectorAll("[data-header-search-button]"));
const closeButtons = overlay.querySelectorAll("[data-header-search-close]");
const dismissTarget = overlay.querySelector("[data-header-search-dismiss]");
const panel = overlay.querySelector("[data-header-search-panel]");
const overlayMobileClass = "header-search-overlay--mobile";
const panelMobileClass = "header-search-panel--mobile";
let lastTrigger = null;
let lastVariant = null;
const setExpandedState = (isOpen) => {
const expanded = isOpen ? "true" : "false";
getSearchButtons().forEach((button) => {
button.setAttribute("aria-expanded", expanded);
button.setAttribute("data-active", expanded);
});
overlay.dataset.open = expanded;
overlay.setAttribute("aria-hidden", isOpen ? "false" : "true");
};
const focusSearchInput = () => {
window.requestAnimationFrame(() => {
const input = overlay.querySelector("[data-site-search-input]");
if (input) {
input.focus();
input.select();
}
});
};
const openOverlay = (trigger, options = {}) => {
lastTrigger = trigger ?? document.activeElement;
const variant = options.variant ?? null;
lastVariant = typeof variant === "string" ? variant : null;
overlay.classList.remove("hidden");
overlay.classList.add("flex");
const isMobileVariant = lastVariant === "mobile";
if (isMobileVariant) {
overlay.dataset.variant = "mobile";
} else {
delete overlay.dataset.variant;
}
overlay.classList.toggle(overlayMobileClass, isMobileVariant);
panel?.classList.toggle(panelMobileClass, isMobileVariant);
document.documentElement.classList.add("has-header-search-open");
setExpandedState(true);
focusSearchInput();
};
const closeOverlay = () => {
overlay.classList.add("hidden");
overlay.classList.remove("flex");
document.documentElement.classList.remove("has-header-search-open");
overlay.classList.remove(overlayMobileClass);
panel?.classList.remove(panelMobileClass);
delete overlay.dataset.variant;
setExpandedState(false);
if (lastTrigger instanceof HTMLElement) {
if (
lastVariant === "mobile" &&
typeof lastTrigger.blur === "function"
) {
lastTrigger.blur();
} else if (lastVariant !== "mobile") {
lastTrigger.focus();
}
}
lastTrigger = null;
lastVariant = null;
};
const bindSearchButtons = () => {
getSearchButtons().forEach((button) => {
if (button.dataset.searchButtonInitialized === "true") {
return;
}
button.addEventListener("click", (event) => {
event.preventDefault();
openOverlay(button);
});
button.dataset.searchButtonInitialized = "true";
});
};
if (overlay.dataset.searchInitialized !== "true") {
closeButtons.forEach((button) => {
button.addEventListener("click", () => {
closeOverlay();
});
});
overlay.addEventListener("click", (event) => {
if (event.target === overlay) {
closeOverlay();
}
});
dismissTarget?.addEventListener("click", closeOverlay);
const handleKeydown = (event) => {
const key = "key" in event ? event.key : undefined;
const isShortcut =
!!key &&
key.toLowerCase() === "k" &&
(event.metaKey || event.ctrlKey);
if (isShortcut) {
event.preventDefault();
const buttons = getSearchButtons();
openOverlay(buttons[0] ?? null);
return;
}
if (key === "Escape" && overlay.dataset.open === "true") {
event.preventDefault();
closeOverlay();
}
};
document.addEventListener("keydown", handleKeydown);
document.addEventListener("header:open-search", (event) => {
const detail =
event instanceof CustomEvent && typeof event.detail === "object"
? event.detail
: {};
const trigger =
detail && detail.trigger instanceof HTMLElement
? detail.trigger
: null;
openOverlay(trigger, detail);
});
document.addEventListener("astro:before-swap", () => {
if (overlay.dataset.open === "true") {
closeOverlay();
}
});
overlay.dataset.searchInitialized = "true";
}
bindSearchButtons();
}
const handleAfterSwap = () => {
initializeMobileNavigation();
window.requestAnimationFrame(() => {
initializeHeaderSearch();
});
};
document.addEventListener("astro:after-swap", handleAfterSwap);
handleAfterSwap();

- [All posts](/blog)

### Recent

- [Making private MCP servers reachable without making them public](/blog/connect-private-mcp-servers-to-openai-products)
- [Mastering Codex Remote for engineering](/blog/mastering-codex-remote-for-engineering)
- [How Perplexity Brought Voice Search to Millions Using the Realtime API](/blog/realtime-perplexity-computer)
- [Designing delightful frontends with GPT-5.4](/blog/designing-delightful-frontends-with-gpt-5-4)
- [From prompts to products: One year of Responses](/blog/one-year-of-responses)

### Topics

- [General](/blog/topic/general)
- [API](/blog/topic/api)
- [Apps SDK](/blog/topic/apps-sdk)
- [Audio](/blog/topic/audio)
- [Codex](/blog/topic/codex)

const NAV\_SELECTOR = "nav[data-left-nav]";
const STORAGE\_PREFIX = "left-nav-scroll:";
const INITIALIZED\_ATTRIBUTE = "data-left-nav-scroll-initialized";
const isStorageAvailable = (() => {
try {
const storageKey = `${STORAGE\_PREFIX}\_\_test\_\_`;
sessionStorage.setItem(storageKey, "1");
sessionStorage.removeItem(storageKey);
return true;
} catch (error) {
return false;
}
})();
const getNav = () => document.querySelector(NAV\_SELECTOR);
const getStorageKey = (nav) =>
`${STORAGE\_PREFIX}${nav.dataset.leftNavId ?? "default"}`;
const restoreScrollPosition = (nav) => {
if (!isStorageAvailable) return;
const storedValue = sessionStorage.getItem(getStorageKey(nav));
if (storedValue !== null) {
nav.scrollTop = Number(storedValue);
}
};
const saveScrollPosition = (nav) => {
if (!isStorageAvailable) return;
sessionStorage.setItem(getStorageKey(nav), String(nav.scrollTop));
};
const setupNav = () => {
const nav = getNav();
if (!nav || nav.getAttribute(INITIALIZED\_ATTRIBUTE) === "true") return;
restoreScrollPosition(nav);
nav.addEventListener(
"scroll",
() => {
saveScrollPosition(nav);
},
{ passive: true }
);
nav.setAttribute(INITIALIZED\_ATTRIBUTE, "true");
};
const persistScrollPosition = () => {
const nav = getNav();
if (!nav) return;
saveScrollPosition(nav);
};
const initialize = () => {
setupNav();
const nav = getNav();
if (!nav) return;
restoreScrollPosition(nav);
};
window.addEventListener("pageshow", initialize);
document.addEventListener("astro:page-load", initialize);
document.addEventListener("astro:after-swap", initialize);
document.addEventListener("astro:before-swap", persistScrollPosition);
window.addEventListener("beforeunload", persistScrollPosition);
initialize();
 

window.\_$HY||(e=>{let t=e=>e&&e.hasAttribute&&(e.hasAttribute("data-hk")?e:t(e.host&&e.host.nodeType?e.host:e.parentNode));["click", "input"].forEach((o=>document.addEventListener(o,(o=>{if(!e.events)return;let s=t(o.composedPath&&o.composedPath()[0]||o.target);s&&!e.completed.has(s)&&e.events.push([s,o])}))))})(\_$HY={events:[],completed:new WeakSet,r:{},fe(){}});

Copy Page

Copy Page

Jan 22, 2026 Codex

# Testing Agent Skills Systematically with Evals

A practical guide to turning agent skills into something you can test, score, and improve over time.

Authors: Dominik Kundel, Gabriel Chua

![Testing Agent Skills Systematically with Evals](/images/blog/eval-skills.png)

When you’re iterating on a skill for an agent like Codex, it’s hard to tell whether you’re actually improving it or just changing its behavior. One version feels faster, another seems more reliable, and then a regression slips in: the skill doesn’t trigger, it skips a required step, or it leaves extra files behind.

At its core, a skill is an [organized collection of prompts and instructions](https://developers.openai.com/codex/skills) for an LLM. The most reliable way to improve a skill over time is to evaluate it the same way you would [any other prompt for LLM applications](https://platform.openai.com/docs/guides/evaluation-best-practices).

*Evals* (short for *evaluations*) check whether a model’s output, and the steps it took to produce it, match what you intended. Instead of asking “does this feel better?” (or relying on vibes), evals let you ask concrete questions like:

- Did the agent invoke the skill?
- Did it run the expected commands?
- Did it produce outputs that follow the conventions you care about?

Concretely, an eval is: a prompt → a captured run (trace + artifacts) → a small set of checks → a score you can compare over time.

In practice, evals for agent skills look a lot like lightweight end-to-end tests: you run the agent, record what happened, and score the result against a small set of rules.

This post walks through a clear pattern for doing that with Codex, starting from defining success, then adding deterministic checks and rubric-based grading so improvements (and regressions) are clear.

## **1. Define success before you write the skill**

Before writing the skill itself, write down what “success” means in terms you can actually measure. A useful way to think about this is to split your checks into a few categories:

- **Outcome goals:** Did the task complete? Does the app run?
- **Process goals:** Did Codex invoke the skill and follow the tools and steps you intended?
- **Style goals:** Does the output follow the conventions you asked for?
- **Efficiency goals:** Did it get there without thrashing (for example, unnecessary commands or excessive token use)?

Keep this list small and focused on must-pass checks. The goal isn’t to encode every preference up front, but to capture the behaviors you care about most.

In this post, for example, the guide evaluates a skill that sets up a demo app. Some checks are concrete. Did it run `npm install`? Did it create `package.json`? The guide pairs those with a structured style rubric to evaluate conventions and layout.

This mix is intentional. You want fast, targeted signals that surface specific regressions early, rather than a single pass/fail verdict at the end.

## **2. Create the skill**

A Codex skill is a directory with a `SKILL.md` file that includes YAML front matter (`name`, `description`), followed by the Markdown instructions that define the skill’s behavior and optional resources and scripts. The name and description matter more than they might seem. They’re the primary signals Codex uses to decide *whether* to invoke the skill at all, and *when* to inject the rest of `SKILL.md` into the agent’s context. If these are vague or overloaded, the skill won’t trigger reliably.

The fastest way to get started is to use Codex’s built-in skill creator ([which itself is also a skill](https://github.com/openai/skills/tree/main/skills/.system/skill-creator)). It walks you through:

```
$skill-creator
```

The creator asks you what the skill does, when it should trigger, and whether it’s instruction-only or script-backed (instruction-only is the default recommendation). To learn more about creating a skill, [check out the documentation](/codex/skills#create-a-skill).

### **A sample skill**

This post uses an intentionally minimal example: a skill that sets up a small React demo app in a predictable, repeatable way.

This skill will:

- Scaffold a project using Vite’s React + TypeScript template
- Configure Tailwind CSS using the official Vite plugin approach
- Enforce a minimal, consistent file structure
- Define a clear “definition of done” so success is straightforward to evaluate

Below is a compact draft you can paste either into:

- `.codex/skills/setup-demo-app/SKILL.md` (repo-scoped), or
- `~/.codex/skills/setup-demo-app/SKILL.md` (user-scoped).

```
---
name: setup-demo-app
description: Scaffold a Vite + React + Tailwind demo app with a small, consistent project structure.
---

## When to use this

Use when you need a fresh demo app for quick UI experiments or reproductions.

## What to build

Create a Vite React TypeScript app and configure Tailwind. Keep it minimal.

Project structure after setup:

- src/
  - main.tsx (entry)
  - App.tsx (root UI)
  - components/
    - Header.tsx
    - Card.tsx
  - index.css (Tailwind import)
- index.html
- package.json

Style requirements:

- TypeScript components
- Functional components only
- Tailwind classes for styling (no CSS modules)
- No extra UI libraries

## Steps

1. Scaffold with Vite using the React TS template:
   npm create vite@latest demo-app -- --template react-ts

2. Install dependencies:
   cd demo-app
   npm install

3. Install and configure Tailwind using the Vite plugin.
   - npm install tailwindcss @tailwindcss/vite
   - Add the tailwind plugin to vite.config.ts
   - In src/index.css, replace contents with:
     @import "tailwindcss";

4. Implement the minimal UI:
   - Header: app title and short subtitle
   - Card: reusable card container
   - App: render Header + 2 Cards with placeholder text

## Definition of done

- npm run dev starts successfully
- package.json exists
- src/components/Header.tsx and src/components/Card.tsx exist
```

This sample skill takes an opinionated stance on purpose. Without clear constraints, there’s nothing concrete to evaluate.

## **3. Manually trigger the skill to expose hidden assumptions**

Because skill invocation depends so much on the *name* and *description* in `SKILL.md`, the first thing to check is whether the `setup-demo-app` skill triggers when you expect it to.

Early on, explicitly activate the skill, either via the `/skills` slash command or by referencing it with the `$` prefix, in a real repository or a scratch directory, and watch where it breaks. This is where you surface the misses: cases where the skill doesn’t trigger at all, triggers too eagerly, or runs but deviates from the intended steps.

At this stage, you’re not optimizing for speed or polish. You’re looking for hidden assumptions the skill is making, such as:

- **Triggering assumptions**: Prompts like “set up a quick React demo” that *should* invoke `setup-demo-app` but don’t, or more generic prompts (“add Tailwind styling”) that unintentionally trigger it.
- **Environment assumptions**: The skill assumes it’s running in an empty directory, or that `npm` is available and preferred over other package managers.
- **Execution assumptions**: The agent skips `npm install` because it assumes dependencies are already installed, or configures Tailwind before the Vite project exists.

Once you’re ready to make these runs repeatable, switch to `codex exec`. It’s designed for automation and CI: it streams progress to `stderr` and writes only the final result to `stdout`, which makes runs easier to script, capture, and inspect.

By default, `codex exec` runs in a restricted sandbox. If your task needs to write files, run it with `--full-auto`. As a general rule, especially when automating, use the least permissions needed to get the job done.

A basic manual run might look like:

```
codex exec --full-auto \
  'Use the $setup-demo-app skill to create the project in this directory.'
```

This first hands-on pass is less about validating correctness and more about discovering edge cases. Every manual fix you make here, such as adding a missing `npm install`, correcting the Tailwind setup, or tightening the trigger description, is a candidate for a future eval, so you can lock in the intended behavior before evaluating at scale.

## **4. Use a small, targeted prompt set to catch regressions early**

You don’t need a large benchmark to get value from evals. For a single skill, a small set of 10–20 prompts is enough to surface regressions and confirm improvements early.

Start with a small CSV and grow it over time as you encounter real failures during development or usage. Each row should represent a situation where you care whether the `setup-demo-app` skill *does* or *does not* activate, and what success looks like when it does.

For example, an initial `evals/setup-demo-app.prompts.csv` might look like this:

```
id,should_trigger,prompt
test-01,true,"Create a demo app named `devday-demo` using the $setup-demo-app skill"
test-02,true,"Set up a minimal React demo app with Tailwind for quick UI experiments"
test-03,true,"Create a small demo app to showcase the Responses API"
test-04,false,"Add Tailwind styling to my existing React app"
```

Each of these cases is testing something slightly different:

- **Explicit invocation (`test-01`)**  
  This prompt names the skill directly. It ensures that Codex can invoke `setup-demo-app` when asked, and that changes to the skill’s name, description, or instructions don’t break direct usage.
- **Implicit invocation (`test-02`)**  
  This prompt describes *exactly* the scenario the skill targets, setting up a minimal React + Tailwind demo, without mentioning the skill by name. It tests whether the name and description in `SKILL.md` are strong enough for Codex to select the skill on its own.
- **Contextual invocation (`test-03`)**  
  This prompt adds domain context (the Responses API) but still requires the same underlying setup. It checks that the skill triggers in realistic, slightly noisy prompts, and that the resulting app still matches the expected structure and conventions.
- **Negative control (`test-04`)**  
  This prompt should **not** invoke `setup-demo-app`. It’s a common adjacent request (“add Tailwind to an existing app”) that can unintentionally match the skill’s description (“React + Tailwind demo”). Including at least one `should_trigger=false` case helps catch **false positives**, where Codex selects the skill too eagerly and scaffolds a new project when the user wanted an incremental change to an existing one.

This mix is intentional. Some evals should confirm that the skill behaves correctly when invoked explicitly; others should check that it activates in real-world prompts where the user never mentions the skill at all.

As you discover misses, prompts that fail to trigger the skill, or cases where the output drifts from your expectations, add them as new rows. Over time, this small CSV becomes a living record of the scenarios the `setup-demo-app` skill must continue to get right.

Over time, this small dataset becomes a living record of what the skill must continue to get right.

## **5. Get started with lightweight deterministic graders**

This is the core of the evaluation step: use `codex exec --json` so your eval harness can score *what actually happened*, not just whether the final output looks right.

When you enable `--json`, `stdout` becomes a JSONL stream of structured events. That makes it straightforward to write deterministic checks tied directly to the behavior you care about, for example:

- Did it run `npm install`?
- Did it create `package.json`?
- Did it invoke the expected commands, in the expected order?

These checks are intentionally lightweight. They give you fast, explainable signals before you add any model-based grading.

### **A minimal Node.js runner**

A “good enough” approach looks like this:

1. For each prompt, run `codex exec --json --full-auto "<prompt>"`
2. Save the JSONL trace to disk
3. Parse the trace and run deterministic checks over the events

```
// evals/run-setup-demo-app-evals.mjs
import { spawnSync } from "node:child_process";
import { readFileSync, writeFileSync, existsSync, mkdirSync } from "node:fs";
import path from "node:path";

function runCodex(prompt, outJsonlPath) {
  const res = spawnSync(
    "codex",
    [
      "exec",
      "--json", // REQUIRED: emit structured events
      "--full-auto", // Allow file system changes
      prompt,
    ],
    { encoding: "utf8" }
  );

  mkdirSync(path.dirname(outJsonlPath), { recursive: true });

  // stdout is JSONL when --json is enabled
  writeFileSync(outJsonlPath, res.stdout, "utf8");

  return { exitCode: res.status ?? 1, stderr: res.stderr };
}

function parseJsonl(jsonlText) {
  return jsonlText
    .split("\n")
    .filter(Boolean)
    .map((line) => JSON.parse(line));
}

// deterministic check: did the agent run `npm install`?
function checkRanNpmInstall(events) {
  return events.some(
    (e) =>
      (e.type === "item.started" || e.type === "item.completed") &&
      e.item?.type === "command_execution" &&
      typeof e.item?.command === "string" &&
      e.item.command.includes("npm install")
  );
}

// deterministic check: did `package.json` get created?
function checkPackageJsonExists(projectDir) {
  return existsSync(path.join(projectDir, "package.json"));
}

// Example single-case run
const projectDir = process.cwd();
const tracePath = path.join(projectDir, "evals", "artifacts", "test-01.jsonl");

const prompt =
  "Create a demo app named demo-app using the $setup-demo-app skill";

runCodex(prompt, tracePath);

const events = parseJsonl(readFileSync(tracePath, "utf8"));

console.log({
  ranNpmInstall: checkRanNpmInstall(events),
  hasPackageJson: checkPackageJsonExists(path.join(projectDir, "demo-app")),
});
```

The value here is that everything is **deterministic and debuggable**.

If a check fails, you can open the JSONL file and see exactly what happened. Every command execution appears as an `item.*` event, in order. That makes regressions straightforward to explain and fix, which is exactly what you want at this stage.

## **6. Conduct qualitative checks with Codex and rubric-based grading**

Deterministic checks answer *“did it do the basics?”* but they don’t answer *“did it do it the way you wanted?”*

For skills like `setup-demo-app`, many requirements are qualitative: component structure, styling conventions, or whether Tailwind follows the intended configuration. These are hard to capture with basic file existence checks or command counts alone.

A pragmatic solution is to add a second, model-assisted step to your eval pipeline:

1. Run the setup skill (this writes code to disk)
2. Run a **read-only style check** against the resulting repository
3. Require a **structured response** that your harness can score consistently

Codex supports this directly via `--output-schema`, which constrains the final response to a JSON Schema you define.

### **A small rubric schema**

Start by defining a small schema that captures the checks you care about. For example, create `evals/style-rubric.schema.json`:

```
{
  "type": "object",
  "properties": {
    "overall_pass": { "type": "boolean" },
    "score": { "type": "integer", "minimum": 0, "maximum": 100 },
    "checks": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": { "type": "string" },
          "pass": { "type": "boolean" },
          "notes": { "type": "string" }
        },
        "required": ["id", "pass", "notes"],
        "additionalProperties": false
      }
    }
  },
  "required": ["overall_pass", "score", "checks"],
  "additionalProperties": false
}
```

This schema gives you stable fields (`overall_pass`, `score`, per-check results) that you can combine, diff, and track over time.

### **The style-check prompt**

Next, run a second `codex exec` that *only inspects the repository* and emits a rubric-compliant JSON response:

```
codex exec \
  "Evaluate the demo-app repository against these requirements:
   - Vite + React + TypeScript project exists
   - Tailwind is configured via @tailwindcss/vite and CSS imports tailwindcss
   - src/components contains Header.tsx and Card.tsx
   - Components are functional and styled with Tailwind utility classes (no CSS modules)
   Return a rubric result as JSON with check ids: vite, tailwind, structure, style." \
  --output-schema ./evals/style-rubric.schema.json \
  -o ./evals/artifacts/test-01.style.json
```

This is where `--output-schema` is handy. Instead of free-form text that’s hard to parse or compare, you get a predictable JSON object that your eval harness can score across many runs.

If you later move this eval suite into CI, the Codex GitHub Action explicitly supports passing `--output-schema` through `codex-args`, so you can enforce the same structured output in automated workflows.

## **7. Extending your evals as the skill matures**

Once you have the core loop in place, you can extend your evals in the directions that matter most for your skill. Start small, then layer in deeper checks only where they add real confidence.

Some examples include:

- **Command count and thrashing:** Count `command_execution` items in the JSONL trace to catch regressions where the agent starts looping or re-running commands. Token usage is also available in `turn.completed` events.
- **Token budget:** Track `usage.input_tokens` and `usage.output_tokens` to spot accidental prompt bloat and compare efficiency across versions.
- **Build checks:** Run `npm run build` after the skill completes. This acts as a stronger end-to-end signal and catches broken imports or incorrectly configured tooling.
- **Runtime smoke checks:** Start `npm run dev` and hit the dev server with `curl`, or run a lightweight Playwright check if you already have one. Use this selectively. It adds confidence but costs time.
- **Repository cleanliness:** Ensure the run generates no unwanted files and that `git status --porcelain` is empty (or matches an explicit allow list).
- **Sandbox and permission regressions:** Verify the skill still works without escalating permissions beyond what you intended. Least-privilege defaults matter most once you automate.

The pattern is consistent: begin with fast checks that explain behavior, then add slower, heavier checks only when they reduce risk.

## **8. Key takeaways**

This small `setup-demo-app` example shows the shift from “it feels better” to “proof”: run the agent, record what happened, and grade it with a small set of checks. Once that loop exists, every tweak becomes easier to confirm, and every regression becomes clear. Here are the key takeaways:

- **Measure what matters.** Good evals make regressions clear and failures explainable.
- **Start from a checkable definition of done.** Use `$skill-creator` to bootstrap, then tighten the instructions until success is unambiguous.
- **Ground evals in behavior.** Capture JSONL with `codex exec --json` and write deterministic checks against `command_execution` events.
- **Use Codex where rules fall short.** Add a structured, rubric-based pass with `--output-schema` to grade style and conventions reliably.
- **Let real failures drive coverage.** Every manual fix is a signal. Turn it into a test so the skill keeps getting it right.

(()=>{var e=async t=>{await(await t())()};(self.Astro||(self.Astro={})).only=e;window.dispatchEvent(new Event("astro:only"));})();  var o="@vercel/speed-insights",u="1.3.1",f=()=>{window.si||(window.si=function(...r){(window.siq=window.siq||[]).push(r)})};function l(){return typeof window<"u"}function h(){try{const e="production"}catch{}return"production"}function d(){return h()==="development"}function v(e,r){if(!e||!r)return e;let n=e;try{const t=Object.entries(r);for(const[s,i]of t)if(!Array.isArray(i)){const a=c(i);a.test(n)&&(n=n.replace(a,`/[${s}]`))}for(const[s,i]of t)if(Array.isArray(i)){const a=c(i.join("/"));a.test(n)&&(n=n.replace(a,`/[...${s}]`))}return n}catch{return e}}function c(e){return new RegExp(`/${g(e)}(?=[/?#]|$)`)}function g(e){return e.replace(/[.\*+?^${}()|[\]\\]/g,"\\$&")}function m(e){return e.scriptSrc?e.scriptSrc:d()?"https://va.vercel-scripts.com/v1/speed-insights/script.debug.js":e.dsn?"https://va.vercel-scripts.com/v1/speed-insights/script.js":e.basePath?`${e.basePath}/speed-insights/script.js`:"/\_vercel/speed-insights/script.js"}function w(e={}){var r;if(!l()||e.route===null)return null;f();const n=m(e);if(document.head.querySelector(`script[src\*="${n}"]`))return null;e.beforeSend&&((r=window.si)==null||r.call(window,"beforeSend",e.beforeSend));const t=document.createElement("script");return t.src=n,t.defer=!0,t.dataset.sdkn=o+(e.framework?`/${e.framework}`:""),t.dataset.sdkv=u,e.sampleRate&&(t.dataset.sampleRate=e.sampleRate.toString()),e.route&&(t.dataset.route=e.route),e.endpoint?t.dataset.endpoint=e.endpoint:e.basePath&&(t.dataset.endpoint=`${e.basePath}/speed-insights/vitals`),e.dsn&&(t.dataset.dsn=e.dsn),d()&&e.debug===!1&&(t.dataset.debug="false"),t.onerror=()=>{console.log(`[Vercel Speed Insights] Failed to load script from ${n}. Please check if any content blockers are enabled and try again.`)},document.head.appendChild(t),{setRoute:s=>{t.dataset.route=s??void 0}}}function p(){try{return}catch{}}customElements.define("vercel-speed-insights",class extends HTMLElement{constructor(){super();try{const r=JSON.parse(this.dataset.props??"{}"),n=JSON.parse(this.dataset.params??"{}"),t=v(this.dataset.pathname??"",n);w({route:t,...r,framework:"astro",basePath:p(),beforeSend:window.speedInsightsBeforeSend})}catch(r){throw new Error(`Failed to parse SpeedInsights properties: ${r}`)}}});

Ask AI

## Docs agent

Loading docs agent...

(() => {
const registry = window.customElements;
if (!registry || window.\_\_docsAgentChatKitMoveGuardInstalled) return;
window.\_\_docsAgentChatKitMoveGuardInstalled = true;
// Astro preserves the launcher with Element.moveBefore(). Registering this
// callback before ChatKit is defined prevents its reconnect hooks from
// replacing the live message-bridge iframe during that move.
const registryPrototype = Object.getPrototypeOf(registry);
const defineDescriptor = Object.getOwnPropertyDescriptor(
registryPrototype,
"define"
);
if (!defineDescriptor?.value) return;
Object.defineProperty(registryPrototype, "define", {
...defineDescriptor,
value(name, constructor, options) {
if (
name === "openai-chatkit" &&
!("connectedMoveCallback" in constructor.prototype)
) {
Object.defineProperty(
constructor.prototype,
"connectedMoveCallback",
{
configurable: true,
value() {},
}
);
}
const result = defineDescriptor.value.call(
this,
name,
constructor,
options
);
if (name === "openai-chatkit") {
Object.defineProperty(registryPrototype, "define", defineDescriptor);
}
return result;
},
});
})();
function initializeDocsAgentLauncher() {
const root = document.querySelector("[data-docs-agent-root]");
if (!root || root.dataset.initialized === "true") return;
if (typeof window.\_\_createDocsAgentNavigationQueue !== "function") return;
const mobileOpenButton = root.querySelector("button[data-docs-agent-open]");
const closeButton = root.querySelector("[data-docs-agent-close]");
const newButton = root.querySelector("[data-docs-agent-new]");
const panel = root.querySelector("[data-docs-agent-panel]");
const status = root.querySelector("[data-docs-agent-status]");
let chatkit = root.querySelector("openai-chatkit");
const apiURL = root.dataset.chatkitApiUrl;
const domainKey = root.dataset.chatkitDomainKey || "local-dev";
const startGreeting =
root.dataset.chatkitGreeting || "OpenAI developer docs";
const startPromptsByParentRoute = (() => {
try {
const parsed = JSON.parse(
root.dataset.chatkitStartPromptsByRoute || "{}"
);
return parsed && typeof parsed === "object" && !Array.isArray(parsed)
? parsed
: {};
} catch {
return {};
}
})();
const docsAgentSessionStorageKey = "docs-agent.chatkit-session-id";
const uuidPattern =
/^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const randomUuid = () => {
if (window.crypto?.randomUUID) {
return window.crypto.randomUUID();
}
const bytes = new Uint8Array(16);
if (window.crypto?.getRandomValues) {
window.crypto.getRandomValues(bytes);
} else {
for (let index = 0; index < bytes.length; index += 1) {
bytes[index] = Math.floor(Math.random() \* 256);
}
}
bytes[6] = (bytes[6] & 0x0f) | 0x40;
bytes[8] = (bytes[8] & 0x3f) | 0x80;
const hex = Array.from(bytes, (byte) =>
byte.toString(16).padStart(2, "0")
);
return [
hex.slice(0, 4).join(""),
hex.slice(4, 6).join(""),
hex.slice(6, 8).join(""),
hex.slice(8, 10).join(""),
hex.slice(10, 16).join(""),
].join("-");
};
let docsAgentSessionIdValue = null;
const storeDocsAgentSessionId = (sessionId) => {
docsAgentSessionIdValue = sessionId;
try {
window.sessionStorage.setItem(docsAgentSessionStorageKey, sessionId);
} catch {
// Ignore storage failures.
}
return sessionId;
};
const resetDocsAgentSessionId = () =>
storeDocsAgentSessionId(randomUuid().toLowerCase());
const docsAgentSessionId = () => {
if (
docsAgentSessionIdValue &&
uuidPattern.test(docsAgentSessionIdValue)
) {
return docsAgentSessionIdValue.toLowerCase();
}
try {
const stored = window.sessionStorage.getItem(
docsAgentSessionStorageKey
);
if (stored && uuidPattern.test(stored)) {
docsAgentSessionIdValue = stored.toLowerCase();
return docsAgentSessionIdValue;
}
} catch {
// Fall through and create an in-memory session id.
}
return resetDocsAgentSessionId();
};
if (
!mobileOpenButton ||
!closeButton ||
!newButton ||
!(panel instanceof HTMLElement) ||
!chatkit ||
!apiURL
) {
return;
}
let chatkitInitialized = false;
let chatkitResponseActive = false;
let chatkitTurnActive = false;
let docsAgentNavigationInProgress = false;
let chatkitReplacement = null;
let desiredPathname = window.location.pathname || "/";
let previousFocus = null;
let lastPageSelection = { text: "", capturedAt: 0 };
let conversationStartedTracked = false;
const selectedTextLimit = 3000;
const staleSelectionMs = 2 \* 60 \* 1000;
const docsAgentRequestTimeoutMs = 40 \* 1000;
const docsAgentNavigationTimeoutMs = 8 \* 1000;
const docsAgentTransitionWaitTimeoutMs = 15 \* 1000;
const docsAgentInitializationTimeoutMs = 15 \* 1000;
const docsAgentUnavailableMessage =
"The docs agent couldn't complete the request. Please retry.";
const chatKitUserTurnTypes = new Set([
"threads.create",
"threads.add\_user\_message",
"threads.retry\_after\_item",
]);
const desktopPanelMedia = window.matchMedia("(min-width: 768px)");
const withTimeout = (operation, timeoutMs, message) =>
new Promise((resolve, reject) => {
const timeout = window.setTimeout(
() => reject(new Error(message)),
timeoutMs
);
Promise.resolve(operation).then(
(value) => {
window.clearTimeout(timeout);
resolve(value);
},
(error) => {
window.clearTimeout(timeout);
reject(error);
}
);
});
const requestDeadlineSignal = (existingSignal) => {
const controller = new AbortController();
const abort = (signal) => controller.abort(signal?.reason);
if (existingSignal) {
if (existingSignal.aborted) {
abort(existingSignal);
} else {
existingSignal.addEventListener(
"abort",
() => abort(existingSignal),
{
once: true,
}
);
}
}
window.setTimeout(
() => controller.abort(new Error("Docs agent request timed out")),
docsAgentRequestTimeoutMs
);
return controller.signal;
};
const chatKitErrorFrame = (message = docsAgentUnavailableMessage) =>
new TextEncoder().encode(
`data: ${JSON.stringify({
type: "error",
code: "custom",
message,
allow\_retry: true,
})}\n\n`
);
const chatKitErrorResponse = (message = docsAgentUnavailableMessage) =>
new Response(chatKitErrorFrame(message), {
status: 200,
headers: {
"content-type": "text/event-stream; charset=utf-8",
"cache-control": "no-cache",
},
});
const chatKitFrameHasTerminalEvent = (frame) => {
const data = frame
.split("\n")
.filter((line) => line.startsWith("data: "))
.map((line) => line.slice("data: ".length))
.join("\n");
if (!data) return false;
try {
const payload = JSON.parse(data);
if (payload?.type === "error") return true;
return (
payload?.type === "thread.item.done" &&
payload?.item?.type === "assistant\_message" &&
Array.isArray(payload.item.content) &&
payload.item.content.some(
(part) =>
typeof part?.text === "string" && Boolean(part.text.trim())
)
);
} catch {
return false;
}
};
const observeChatKitTerminalEvents = (state, chunk, final = false) => {
state.buffer += chunk
? state.decoder.decode(chunk, { stream: !final })
: state.decoder.decode();
state.buffer = state.buffer.replace(/\r\n/g, "\n");
const frames = state.buffer.split("\n\n");
const trailingFrame = frames.pop() || "";
state.buffer = final ? "" : trailingFrame;
for (const frame of frames) {
if (chatKitFrameHasTerminalEvent(frame)) state.emitted = true;
}
if (
final &&
trailingFrame &&
chatKitFrameHasTerminalEvent(trailingFrame)
) {
state.emitted = true;
}
};
const ensureUserTurnTerminalResponse = (response) => {
if (!response.body) return chatKitErrorResponse();
const reader = response.body.getReader();
const state = {
decoder: new TextDecoder(),
buffer: "",
emitted: false,
};
const body = new ReadableStream({
async pull(controller) {
try {
const result = await reader.read();
if (result.done) {
observeChatKitTerminalEvents(state, null, true);
if (!state.emitted) controller.enqueue(chatKitErrorFrame());
controller.close();
return;
}
observeChatKitTerminalEvents(state, result.value);
controller.enqueue(result.value);
} catch {
if (!state.emitted) controller.enqueue(chatKitErrorFrame());
controller.close();
}
},
cancel(reason) {
void reader.cancel(reason).catch(() => undefined);
},
});
return new Response(body, {
status: response.status,
statusText: response.statusText,
headers: response.headers,
});
};
const syncOpenButtons = (expanded) => {
document
.querySelectorAll("button[data-docs-agent-open]")
.forEach((button) => {
button.setAttribute("aria-expanded", expanded);
});
};
const syncLayoutTargets = () => {
const isOpen = root.dataset.open === "true";
const isDesktopPanel = desktopPanelMedia.matches;
document.body.classList.toggle("docs-agent-open", isOpen);
if (isOpen) {
document.body.dataset.docsAgentOpen = "true";
} else {
delete document.body.dataset.docsAgentOpen;
}
syncOpenButtons(isOpen ? "true" : "false");
document.querySelectorAll("[data-docs-agent-page]").forEach((page) => {
if (page instanceof HTMLElement) {
page.classList.toggle("is-docs-agent-open", isOpen);
page.style.width =
isOpen && isDesktopPanel
? "calc(100% - var(--docs-agent-panel-width))"
: "";
page.style.transform = isOpen
? isDesktopPanel
? "none"
: "translateY(calc(-1 \* var(--docs-agent-drawer-height)))"
: "";
}
});
const header = document.getElementById("header");
header?.classList.toggle("is-docs-agent-open", isOpen);
if (header) {
const headerInner = header.firstElementChild;
const headerNav = header.querySelector("nav");
const headerSearchButton = header.querySelector(
"[data-header-search-button]"
);
header.style.width =
isOpen && isDesktopPanel
? "calc(100% - var(--docs-agent-panel-width))"
: "";
if (headerInner instanceof HTMLElement) {
headerInner.style.gridTemplateColumns =
isOpen && isDesktopPanel ? "auto minmax(0, 1fr) auto" : "";
}
if (headerNav instanceof HTMLElement) {
headerNav.style.minWidth = isOpen && isDesktopPanel ? "0" : "";
headerNav.style.overflow = "";
}
if (headerSearchButton instanceof HTMLElement) {
headerSearchButton.style.display =
isOpen && isDesktopPanel ? "none" : "";
}
}
panel.classList.toggle("is-open", isOpen);
panel.style.transform = isOpen
? isDesktopPanel
? "translateX(0)"
: "translateY(0)"
: "";
};
const normalizeAnalyticsText = (value) =>
typeof value === "string" ? value.replace(/\s+/g, " ").trim() : "";
const analyticsSlug = (value, fallback) => {
const slug = normalizeAnalyticsText(value)
.toLowerCase()
.replace(/[^a-z0-9]+/g, "\_")
.replace(/^\_+|\_+$/g, "");
return slug || fallback;
};
const normalizePathname = (pathname) => {
if (!pathname || pathname === "/") return "/";
return pathname.replace(/\/+$/, "") || "/";
};
const docsAgentParentRoute = (pathname) => {
const normalized = normalizePathname(pathname);
if (normalized === "/") return "home";
if (normalized === "/api" || normalized.startsWith("/api/")) {
return "api";
}
if (normalized === "/codex" || normalized.startsWith("/codex/")) {
return "codex";
}
if (
normalized === "/chatgpt" ||
normalized.startsWith("/chatgpt/") ||
normalized === "/apps-sdk" ||
normalized.startsWith("/apps-sdk/") ||
normalized === "/commerce" ||
normalized.startsWith("/commerce/")
) {
return "chatgpt";
}
if (
normalized === "/learn" ||
normalized.startsWith("/learn/") ||
normalized === "/community" ||
normalized.startsWith("/community/") ||
normalized === "/cookbook" ||
normalized.startsWith("/cookbook/") ||
normalized === "/showcase" ||
normalized.startsWith("/showcase/") ||
normalized === "/tracks" ||
normalized.startsWith("/tracks/") ||
normalized === "/blog" ||
normalized.startsWith("/blog/")
) {
return "resources";
}
return "home";
};
const startPromptsForRoute = (
pathname = window.location.pathname || "/"
) => {
const parentRoute = docsAgentParentRoute(pathname);
const prompts = startPromptsByParentRoute[parentRoute];
if (Array.isArray(prompts)) return prompts;
return Array.isArray(startPromptsByParentRoute.home)
? startPromptsByParentRoute.home
: [];
};
const startPromptAnalyticsForRoute = (pathname) =>
startPromptsForRoute(pathname)
.map((prompt, index) => {
const promptText = normalizeAnalyticsText(prompt?.prompt);
if (!promptText) return null;
return {
id: analyticsSlug(prompt?.label, `prompt\_${index + 1}`),
label:
normalizeAnalyticsText(prompt?.label) || `Prompt ${index + 1}`,
position: index + 1,
text: promptText,
};
})
.filter(Boolean);
const normalizeSelectedText = (value) =>
value.replace(/\r\n?/g, "\n").trim().slice(0, selectedTextLimit);
const nodeIsInDocsAgent = (node) => {
if (!node) return false;
const element =
node.nodeType === Node.ELEMENT\_NODE ? node : node.parentElement;
return element instanceof Element && root.contains(element);
};
const currentPageSelectionText = () => {
const selection = window.getSelection?.();
if (!selection || selection.isCollapsed) return "";
if (
nodeIsInDocsAgent(selection.anchorNode) ||
nodeIsInDocsAgent(selection.focusNode)
) {
return "";
}
return normalizeSelectedText(selection.toString());
};
const rememberPageSelection = () => {
const text = currentPageSelectionText();
if (!text) return;
lastPageSelection = {
text,
capturedAt: Date.now(),
};
};
const selectedTextForAgentContext = () => {
const text = currentPageSelectionText();
if (text) {
lastPageSelection = {
text,
capturedAt: Date.now(),
};
return text;
}
if (Date.now() - lastPageSelection.capturedAt <= staleSelectionMs) {
return lastPageSelection.text;
}
return "";
};
const docsAgentPageContext = () => {
const context = {
route: window.location.pathname || "/",
};
const selectedText = selectedTextForAgentContext();
if (selectedText) {
context.selectedText = selectedText;
}
return context;
};
const hasPageSelectionForAnalytics = () => {
if (currentPageSelectionText()) return true;
return Date.now() - lastPageSelection.capturedAt <= staleSelectionMs
? Boolean(lastPageSelection.text)
: false;
};
const chatKitRequestInputText = (body) => {
const content = body?.params?.input?.content;
if (!Array.isArray(content)) return "";
return content
.map((part) =>
part?.type === "input\_text" && typeof part.text === "string"
? part.text
: ""
)
.filter(Boolean)
.join("\n")
.trim();
};
const defaultPromptMatch = (body) => {
const text = normalizeAnalyticsText(chatKitRequestInputText(body));
if (!text) return null;
const startPromptByText = new Map(
startPromptAnalyticsForRoute(window.location.pathname || "/").map(
(prompt) => [prompt.text, prompt]
)
);
return startPromptByText.get(text) || null;
};
const promptAnalyticsData = (prompt) =>
prompt
? {
prompt\_id: prompt.id,
prompt\_label: prompt.label,
prompt\_position: prompt.position,
}
: {};
const isDocsAgentApiRequest = (input) => {
try {
const requestUrl =
typeof input === "string" || input instanceof URL
? new URL(input, window.location.href)
: new URL(input.url);
const configuredUrl = new URL(apiURL, window.location.href);
return requestUrl.href === configuredUrl.href;
} catch {
return false;
}
};
const docsAgentFetch = async (input, init) => {
if (!isDocsAgentApiRequest(input)) {
return window.fetch(input, init);
}
const nextInit = init ? { ...init } : {};
if (typeof nextInit.body === "string") {
try {
const body = JSON.parse(nextInit.body);
if (body && typeof body === "object" && !Array.isArray(body)) {
if (body.type === "threads.create" && !conversationStartedTracked) {
const prompt = defaultPromptMatch(body);
const promptData = promptAnalyticsData(prompt);
conversationStartedTracked = true;
trackDocsAgentEvent("docs\_agent\_conversation\_started", {
entry\_point: prompt ? "default\_prompt" : "composer",
request\_type: body.type,
has\_page\_selection: hasPageSelectionForAnalytics(),
...promptData,
});
if (prompt) {
trackDocsAgentEvent("docs\_agent\_default\_prompt\_selected", {
request\_type: body.type,
...promptData,
});
}
}
const metadata =
body.metadata &&
typeof body.metadata === "object" &&
!Array.isArray(body.metadata)
? body.metadata
: {};
body.metadata = {
...metadata,
pageContext: docsAgentPageContext(),
};
nextInit.body = JSON.stringify(body);
}
} catch {
// Preserve the original body if it is not JSON.
}
}
const headers = new Headers(
nextInit.headers ||
(input instanceof Request ? input.headers : undefined)
);
headers.set("x-docs-agent-user", docsAgentSessionId());
nextInit.headers = headers;
nextInit.signal = requestDeadlineSignal(
nextInit.signal || (input instanceof Request ? input.signal : null)
);
let requestType = "";
if (typeof nextInit.body === "string") {
try {
requestType = JSON.parse(nextInit.body)?.type || "";
} catch {
// The proxy will return the protocol validation error.
}
}
const requireTerminalEvent = chatKitUserTurnTypes.has(requestType);
if (requireTerminalEvent) {
chatkitTurnActive = true;
}
try {
const response = await window.fetch(input, nextInit);
return requireTerminalEvent
? ensureUserTurnTerminalResponse(response)
: response;
} catch (error) {
if (requireTerminalEvent) return chatKitErrorResponse();
throw error;
}
};
const clearLegacyStoredState = () => {
try {
window.localStorage.removeItem("docs-agent.panel-open");
window.localStorage.removeItem("docs-agent.thread-id");
window.localStorage.removeItem("docs-agent.user-id");
} catch {
// Ignore storage failures.
}
};
const showStatus = (message) => {
if (!status) return;
status.textContent = message;
status.hidden = false;
};
const hideStatus = () => {
if (status) status.hidden = true;
};
const getColorTheme = () => {
const html = document.documentElement;
return html.dataset.theme === "dark" || html.classList.contains("dark")
? "dark"
: "light";
};
const normalizeClientToolArgs = (args) => {
if (!args) return {};
if (typeof args === "string") {
try {
return JSON.parse(args);
} catch {
return {};
}
}
return args;
};
const analyticsViewport = () =>
window.matchMedia("(min-width: 768px)").matches ? "desktop" : "mobile";
const trackDocsAgentEvent = (name, data = {}) => {
try {
window.\_\_docsAgentTrackEvent?.(name, {
surface: "docs\_agent",
route: window.location.pathname || "/",
viewport: analyticsViewport(),
...data,
});
} catch {
// Ignore analytics failures.
}
};
const navigationTarget = (href) => {
if (typeof href !== "string" || !href.trim()) {
return { ok: false, error: "Missing href." };
}
let url;
try {
url = new URL(href, window.location.origin);
} catch {
return { ok: false, error: "Invalid href." };
}
const originalHost = url.host;
const allowedHosts = new Set([
window.location.host,
"developers.openai.com",
]);
if (!allowedHosts.has(originalHost)) {
return { ok: false, error: "Navigation host is not allowed." };
}
return {
ok: true,
href:
originalHost === window.location.host ||
originalHost === "developers.openai.com"
? `${url.pathname}${url.search}${url.hash}`
: url.toString(),
};
};
const navigateToHref = async (href) => {
const target = navigationTarget(href);
if (!target.ok) return target;
const routeHref = target.href;
if (
routeHref.startsWith("/") &&
typeof window.\_\_docsAgentNavigate === "function"
) {
docsAgentNavigationInProgress = true;
try {
await withTimeout(
window.\_\_docsAgentNavigate(routeHref, { history: "push" }),
docsAgentNavigationTimeoutMs,
"Docs agent navigation timed out"
);
} catch (error) {
console.error("Docs agent navigation failed", error);
return { ok: false, error: "Navigation failed or timed out." };
} finally {
docsAgentNavigationInProgress = false;
}
} else {
window.location.assign(routeHref);
}
return { ok: true, href: routeHref };
};
const navigationQueue =
window.\_\_createDocsAgentNavigationQueue(navigateToHref);
const queueNavigationToHref = (href) => {
const target = navigationTarget(href);
if (!target.ok) return target;
navigationQueue.queue(target.href);
return target;
};
const chatKitTurnSettledCallbacks = new Set();
const chatKitTurnIsActive = () =>
chatkitResponseActive ||
chatkitTurnActive ||
navigationQueue.hasPending();
const notifyChatKitTurnSettled = () => {
if (chatKitTurnIsActive()) return;
for (const callback of chatKitTurnSettledCallbacks) {
callback();
}
chatKitTurnSettledCallbacks.clear();
};
const waitForChatKitTurnToSettle = (signal) => {
if (signal.aborted) return Promise.resolve("aborted");
if (!chatKitTurnIsActive()) return Promise.resolve("settled");
return new Promise((resolve) => {
let timeout;
const finish = (result) => {
window.clearTimeout(timeout);
signal.removeEventListener("abort", onAbort);
chatKitTurnSettledCallbacks.delete(onSettled);
resolve(result);
};
const onAbort = () => finish("aborted");
const onSettled = () => finish("settled");
signal.addEventListener("abort", onAbort, { once: true });
chatKitTurnSettledCallbacks.add(onSettled);
timeout = window.setTimeout(
() => finish("timed-out"),
docsAgentTransitionWaitTimeoutMs
);
});
};
const deferPageTransitionDuringChatKitTurn = (event) => {
if (docsAgentNavigationInProgress || !chatKitTurnIsActive()) return;
const loadPage = event.loader;
event.loader = async () => {
const result = await waitForChatKitTurnToSettle(event.signal);
if (result === "aborted" || event.signal.aborted) return;
if (result === "timed-out") {
// Asking Astro to cancel here makes it fall back to a full load. That
// is safer than moving a ChatKit frame whose turn did not terminate.
event.preventDefault();
return;
}
await loadPage();
};
};
const bindChatKitLifecycle = () => {
if (chatkit.dataset.docsAgentLifecycleBound === "true") return;
chatkit.dataset.docsAgentLifecycleBound = "true";
chatkit.addEventListener("chatkit.thread.change", (event) => {
const threadId = event?.detail?.threadId;
if (threadId === null) {
conversationStartedTracked = false;
}
});
chatkit.addEventListener("chatkit.response.start", () => {
chatkitResponseActive = true;
navigationQueue.onResponseStart();
});
chatkit.addEventListener("chatkit.response.end", () => {
chatkitResponseActive = false;
void navigationQueue
.onResponseEnd()
.then(() => {
if (!navigationQueue.hasPending()) {
chatkitTurnActive = false;
notifyChatKitTurnSettled();
}
})
.catch((error) => {
console.error("Docs agent navigation failed", error);
});
});
chatkit.addEventListener("chatkit.error", () => {
chatkitResponseActive = false;
chatkitTurnActive = false;
navigationQueue.clear();
notifyChatKitTurnSettled();
});
};
const buildChatKitOptions = () => ({
api: {
url: apiURL,
domainKey,
fetch: docsAgentFetch,
},
theme: {
colorScheme: getColorTheme(),
},
header: { enabled: false },
onClientTool(toolCall) {
const args = normalizeClientToolArgs(
toolCall?.params || toolCall?.arguments
);
if (toolCall?.name === "navigate\_to\_page") {
return queueNavigationToHref(args.href);
}
if (toolCall?.name === "open\_custom\_guide") {
const guideHref =
args.href ||
(args.generated\_id ? `/custom-guide/${args.generated\_id}` : "");
trackDocsAgentEvent("docs\_agent\_custom\_guide\_opened", {
source: "client\_tool",
guide\_id: args.generated\_id || "",
href: guideHref,
});
return queueNavigationToHref(guideHref);
}
return {
ok: false,
error: `Unknown client tool: ${toolCall?.name || "unknown"}.`,
};
},
widgets: {
onAction(action) {
const payload = normalizeClientToolArgs(action?.payload);
if (action?.type === "custom\_guide.view") {
const guideHref =
payload.href ||
payload.url ||
(payload.generated\_id
? `/custom-guide/${payload.generated\_id}`
: "");
trackDocsAgentEvent("docs\_agent\_custom\_guide\_opened", {
source: "widget\_action",
guide\_id: payload.generated\_id || "",
href: guideHref,
});
return navigateToHref(guideHref);
}
if (action?.type === "docs\_agent.navigate") {
const href = payload.href || payload.url || "";
trackDocsAgentEvent("docs\_agent\_suggested\_page\_opened", {
source: "widget\_action",
href,
suggestion\_title: payload.title || "",
suggestion\_type: payload.type || "",
});
return navigateToHref(href);
}
return {
ok: false,
error: `Unknown widget action: ${action?.type || "unknown"}.`,
};
},
},
composer: {
placeholder: "Ask about docs or what you want to build",
},
startScreen: {
greeting: startGreeting,
prompts: startPromptsForRoute(desiredPathname),
},
});
const applyChatKitOptions = () => {
chatkit.setOptions(buildChatKitOptions());
};
// Existing ChatKit instances keep the options they were created with.
// Route changes only select the prompts for the next explicit new thread.
const syncDesiredPathnameForPageLoad = () => {
desiredPathname = window.location.pathname || "/";
};
const syncDesiredPathnameBeforeSwap = (event) => {
const destination = event?.to;
if (destination instanceof URL) {
desiredPathname = destination.pathname || "/";
} else if (typeof destination === "string") {
desiredPathname = new URL(destination, window.location.href).pathname;
}
};
const initializeChatKit = async () => {
if (chatkitInitialized) return;
showStatus("Loading docs agent...");
try {
await withTimeout(
customElements.whenDefined("openai-chatkit"),
docsAgentInitializationTimeoutMs,
"Docs agent initialization timed out"
);
bindChatKitLifecycle();
applyChatKitOptions();
chatkitInitialized = true;
hideStatus();
} catch (error) {
console.error("Failed to initialize Docs Agent ChatKit", error);
showStatus("Docs agent is unavailable.");
}
};
const resetChatKit = () => {
if (chatkitReplacement) return chatkitReplacement;
navigationQueue.clear();
chatkitReplacement = (async () => {
const nextChatKit = document.createElement("openai-chatkit");
nextChatKit.id = "docs-agent-chatkit";
nextChatKit.className = "block h-full w-full";
chatkit.replaceWith(nextChatKit);
chatkit = nextChatKit;
chatkitInitialized = false;
chatkitResponseActive = false;
chatkitTurnActive = false;
conversationStartedTracked = false;
resetDocsAgentSessionId();
await initializeChatKit();
notifyChatKitTurnSettled();
})();
void chatkitReplacement.then(
() => {
chatkitReplacement = null;
},
() => {
chatkitReplacement = null;
}
);
return chatkitReplacement;
};
const openPanel = () => {
if (root.dataset.open !== "true") {
trackDocsAgentEvent("docs\_agent\_panel\_opened", {
source: "ask\_button",
has\_page\_selection: hasPageSelectionForAnalytics(),
});
}
previousFocus = document.activeElement;
document.body.dataset.docsAgentOpen = "true";
document.body.classList.add("docs-agent-open");
root.dataset.open = "true";
root.classList.add("is-open");
syncLayoutTargets();
initializeChatKit();
requestAnimationFrame(() => closeButton.focus());
};
const closePanel = () => {
delete document.body.dataset.docsAgentOpen;
document.body.classList.remove("docs-agent-open");
delete root.dataset.open;
root.classList.remove("is-open");
syncLayoutTargets();
if (previousFocus instanceof HTMLElement) {
previousFocus.focus();
}
};
clearLegacyStoredState();
desktopPanelMedia.addEventListener("change", syncLayoutTargets);
document.addEventListener("selectionchange", rememberPageSelection);
document.addEventListener(
"astro:before-preparation",
deferPageTransitionDuringChatKitTurn
);
document.addEventListener(
"astro:before-swap",
syncDesiredPathnameBeforeSwap
);
document.addEventListener("astro:page-load", syncLayoutTargets);
document.addEventListener(
"astro:page-load",
syncDesiredPathnameForPageLoad
);
document.addEventListener("pointerdown", (event) => {
if (
event.target instanceof Element &&
event.target.closest("button[data-docs-agent-open]")
) {
rememberPageSelection();
}
});
document.addEventListener("click", (event) => {
if (
event.target instanceof Element &&
event.target.closest("button[data-docs-agent-open]")
) {
openPanel();
}
});
newButton.addEventListener("click", resetChatKit);
closeButton.addEventListener("click", closePanel);
window.addEventListener("docs-agent:close", closePanel);
panel.addEventListener("keydown", (event) => {
if (event.key === "Escape") {
closePanel();
}
});
root.dataset.initialized = "true";
syncLayoutTargets();
}
document.addEventListener("astro:page-load", initializeDocsAgentLauncher);
window.addEventListener(
"docs-agent:helpers-ready",
initializeDocsAgentLauncher
);
initializeDocsAgentLauncher();
