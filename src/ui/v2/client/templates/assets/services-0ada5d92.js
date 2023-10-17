import{_ as z,o as r,c as g,a as o,f as b,g as F,h as J,i as d,w as l,d as a,b as f,k as w,u as M,F as R,r as B,j as I}from"./_plugin-vue_export-helper-8cf34f94.js";import{u as A,_ as T,f as k,c as L}from"./api-c8d35a00.js";import{_ as G}from"./State-12c471ac.js";import{_ as y}from"./Base-dee1bee9.js";import{b as v,c as E,_ as p,a as D}from"./Base-7e2e8ada.js";import{_ as U}from"./List-b0b9ba9a.js";import{u as W,g as H,_ as q,b as K,a as Q}from"./Structure-0cfe2d7a.js";import{_ as x}from"./Select-ab98952b.js";import{s as X,g as Y,a as Z}from"./plugins-9c6b5ad6.js";const ee={},se={class:"stroke-yellow-600 h-6 w-6",xmlns:"http://www.w3.org/2000/svg",fill:"none",viewBox:"0 0 24 24","stroke-width":"1.5",stroke:"currentColor"},te=o("path",{"stroke-linecap":"round","stroke-linejoin":"round",d:"M12 9v3.75m-9.303 3.376c-.866 1.5.217 3.374 1.948 3.374h14.71c1.73 0 2.813-1.874 1.948-3.374L13.949 3.378c-.866-1.5-3.032-1.5-3.898 0L2.697 16.126zM12 15.75h.007v.008H12v-.008z"},null,-1),ae=[te];function ie(N,m){return r(),g("svg",se,ae)}const le=z(ee,[["render",ie]]),ne={key:0,class:"col-span-12 content-wrap"},ce={class:"col-span-12 flex"},re={class:"col-span-12 flex justify-center mt-2"},oe={class:"col-span-12 flex flex-col justify-center items-center mt-2"},ue=o("hr",{class:"line-separator z-10 w-full"},null,-1),de={class:"dark:text-gray-500 text-xs text-center mt-1 mb-2"},fe={class:"mx-0.5"},ve={class:"col-span-12"},pe={class:"col-span-12 flex w-full justify-center mt-8 mb-2"},ge={__name:"Services",setup(N){const m=W(),_=A(),u=b({keyword:"",method:""}),e=b({isPend:!1,isErr:!1,data:[],activePlugin:"",activeService:"",pluginsName:[],servicesName:[],activePlugins:[],setup:F(()=>{if(e.isErr||e.isPend||!e.data||e.data.length===0||n.isErr||n.isPend||!n.data||n.data.length===0)return[];const c=X(Y(JSON.parse(JSON.stringify(e.data)),"multisite")),s=JSON.parse(JSON.stringify(n.data.services));e.servicesName=[];for(const[i,h]of Object.entries(s)){e.servicesName.push(i);const V=JSON.parse(JSON.stringify(c)),P=s[i];"SERVER_NAME"in P||(P.SERVER_NAME={value:i,method:"default"}),s[i]=Z(V,P)}s.new=JSON.parse(JSON.stringify(c));for(const[i,h]of Object.entries(s))s[i]=H(s[i],u);e.activeService||(e.activeService=e.servicesName[0]);const t=[];return s[e.activeService].forEach(i=>{i.isMatchFilter&&t.push(i.name)}),e.activePlugins=t,e.activePlugin||(e.activePlugin=e.activePlugins.length>0?e.activePlugins[0]:""),e.activePlugin&&(e.activePlugins.indexOf(e.activePlugin)!==-1||(e.activePlugin=e.activePlugins.length>0?e.activePlugins[0]:"")),s})}),n=b({isPend:!1,isErr:!1,data:[]});async function S(){n.isPend=!0,e.isPend=!0,await k("/api/config?methods=1&new_format=1","GET",null,n,_.addFeedback),await k("/api/plugins","GET",null,e,_.addFeedback)}function $(){u.label="",m.$reset()}function C(){S(),$()}function O(c){e.activeService=c,m.$reset()}async function j(){const c=[],s=n.data.services;if(Object.keys(s).length>0)for(const[t,i]of Object.entries(s)){if(Object.keys(i).length===0)continue;const h=t;c.push(await k(`/api/config/service/${h}?method=ui`,"PUT",i,null,_.addFeedback))}Promise.all(c).then(t=>{S()})}return J(async()=>{await S()}),(c,s)=>(r(),d(T,null,{default:l(()=>[a(G,{class:"col-span-4 col-start-5",isErr:e.isErr,isPend:e.isPend,isData:!0},null,8,["isErr","isPend"]),!e.isErr&&!e.isPend?(r(),g("div",ne,[a(v,{class:"z-[102] h-fit col-span-12 md:col-span-4 lg:col-span-3 3xl:col-span-2",label:"info"},{default:l(()=>[a(U,{items:[{label:"total",value:Object.keys(e.setup).length-1},{label:"scheduler",value:""},{label:"ui",value:""}]},null,8,["items"])]),_:1}),a(v,{class:"z-[101] h-fit col-span-12 md:col-span-8 lg:col-span-4 3xl:col-span-3"},{default:l(()=>[o("div",ce,[a(E,{label:"services"}),a(q,{onRefresh:s[0]||(s[0]=t=>C())})]),a(p,{class:"flex w-full col-span-12",label:"Select service",name:"services-list"},{default:l(()=>[e.activeService?(r(),d(x,{key:0,onInp:s[1]||(s[1]=t=>O(t)),settings:{id:"services-list",value:e.activeService==="new"?"":e.activeService,values:Object.keys(e.setup).filter(t=>t!=="new"),placeholder:"Services"}},null,8,["settings"])):f("",!0)]),_:1}),o("div",re,[a(y,{onClick:s[2]||(s[2]=t=>e.activeService="new"),color:"valid",size:"normal",class:"text-sm"},{default:l(()=>[w("Create new service")]),_:1})]),o("div",oe,[ue,o("p",de,[o("span",fe,[a(le,{class:"scale-90"})]),w(" Switching services will reset unsaved changes ")])])]),_:1}),a(v,{label:"plugins",class:"z-[100] col-span-12 md:col-span-12 lg:col-span-5 3xl:col-span-4 grid grid-cols-12 relative"},{default:l(()=>[a(p,{class:"flex w-full col-span-12 2xl:col-span-6",label:"Select plugin",name:"plugins"},{default:l(()=>[a(x,{onInp:s[3]||(s[3]=t=>e.activePlugin=t),settings:{id:"plugins",value:e.activePlugin,values:e.activePlugins,placeholder:"Search"}},null,8,["settings"])]),_:1}),a(p,{class:"flex w-full col-span-12 2xl:col-span-6",label:"Setting search",name:"keyword"},{default:l(()=>[a(D,{onInp:s[4]||(s[4]=t=>u.keyword=t),settings:{id:"keyword",type:"text",value:"",placeholder:"label"}})]),_:1}),a(p,{class:"flex w-full col-span-12 2xl:col-span-6",label:"Setting method",name:"keyword"},{default:l(()=>[a(x,{onInp:s[5]||(s[5]=t=>u.method=t),settings:{id:"keyword",value:"all",values:M(K)(),placeholder:"Search"}},null,8,["settings"])]),_:1})]),_:1}),e.activeService?(r(),d(v,{key:0,class:"z-10 col-span-12 grid grid-cols-12 relative"},{default:l(()=>[a(E,{class:"text-xl border-b pb-2 mb-4",label:e.activeService==="new"?"CREATE NEW SERVICE":`SERVICE ${e.activeService}`},null,8,["label"]),(r(!0),g(R,null,B(e.setup,(t,i)=>(r(),g("div",ve,[e.activeService===i?(r(),d(Q,{key:0,serviceName:i,plugins:t,active:e.activePlugin},null,8,["serviceName","plugins","active"])):f("",!0)]))),256)),o("div",pe,[a(y,{onClick:s[6]||(s[6]=t=>j()),color:"valid",size:"lg"},{default:l(()=>[w(" SAVE ")]),_:1})])]),_:1})):f("",!0)])):f("",!0)]),_:1}))}},me=L();I(ge).use(me).mount("#app");