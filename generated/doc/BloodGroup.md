
<div id="schema-header-title">
  <h2><span id="schema-header-title-project">playground</span> BloodGroup <a href="https://github.com/ga4gh-schemablocks/playground" target="_BLANK">[ &nearr; ]</a></h2>
</div>

<table id="schema-header-table">
<tr>
<th>{S}[B] Status <a href="https://schemablocks.org/about/sb-status-levels.html">[i]</a></th>
<td><div id="schema-header-status">proposed</div></td>
</tr>
<tr><th>Provenance</th><td><ul>
<li>GA4GH Data Connect</li>
</ul></td></tr>
<tr><th>Used by</th><td><ul>
<li>Example schema in Data Connect specification</li>
</ul></td></tr>


<!--more-->
<tr><th>Contributors</th><td><ul>
<li>GA4GH Data Connect Team</li>
<li><a href="https://orcid.org/0000-0001-9135-2164">Jonathan Fuerth</a></li>
</ul></td></tr>
<tr><th>Source (v2021-04-14)</th><td><ul>
<li><a href="current/BloodGroup.json" target="_BLANK">raw source [JSON]</a></li>
<li><a href="https://github.com/ga4gh-schemablocks/playground/blob/master/schemas/BloodGroup.yaml" target="_BLANK">Github</a></li>
</ul></td></tr>
</table>

<div id="schema-attributes-title"><h3>Attributes</h3></div>

  
__Type:__ object  
__Description:__ An OntologyReference constrained to ABO Blood Groups.
TODO: A method to constrain the value space by design, not only through documentation

### Properties

<table id="schema-properties-table">
<tr><th>Property</th><th>Type</th></tr>
<tr><th>id</th><td>https://schemablocks.org/schemas/sb-phenopackets/v1.0.0/OntologyClass.json#/properties [<a href="https://schemablocks.org/schemas/sb-phenopackets/v1.0.0/OntologyClass.json">LINK</a>]</td></tr>
</table>


#### id

* type: https://schemablocks.org/schemas/sb-phenopackets/v1.0.0/OntologyClass.json#/properties [<a href="https://schemablocks.org/schemas/sb-phenopackets/v1.0.0/OntologyClass.json">LINK</a>]

Subtype of HP:0032224 (ABO Blood Group)

##### `id` Value Examples  

```
{
   "id" : "HP:0032442",
   "label" : "O"
}
```
```
{
   "id" : "HP:0032370",
   "label" : "A"
}
```
```
{
   "id" : "HP:0032440",
   "label" : "B"
}
```
```
{
   "id" : "HP:0032441",
   "label" : "AB"
}
```

