
## BlockMeta

### SchemaBlocks Metadata

* {S}[B] Status  [[i]](https://schemablocks.org/about/sb-status-levels.html)
    - __playground__


* Provenance  

    - [Original development for SchemaBlocks project](https://schemablocks.org)  

* Used by  

    - [SchemaBlocks](https://schemablocks.org)  

* Contributors  

    - [Michael Baudis](https://orcid.org/0000-0002-9903-4248)  
<!--more-->

### Properties

<table>
  <tr>
    <th>Property</th>
    <th>Type</th>
  </tr>
  <tr>
    <td>contributors</td>
    <td>array of https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml" target="_BLANK">SRC</a>] [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.html" target="_BLANK">HTML</a>]</td>
  </tr>
  <tr>
    <td>provenance</td>
    <td>array of https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml" target="_BLANK">SRC</a>] [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.html" target="_BLANK">HTML</a>]</td>
  </tr>
  <tr>
    <td>sb_status</td>
    <td>string</td>
  </tr>
  <tr>
    <td>use_cases</td>
    <td>array of https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml" target="_BLANK">SRC</a>] [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.html" target="_BLANK">HTML</a>]</td>
  </tr>

</table>

    
#### contributors

* type: array of https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml" target="_BLANK">SRC</a>] [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.html" target="_BLANK">HTML</a>]



##### `contributors` Value Example  

```
{
   "description" : "Michael Baudis",
   "id" : "orcid:0000-0002-9903-4248"
}
```
    
#### provenance

* type: array of https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml" target="_BLANK">SRC</a>] [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.html" target="_BLANK">HTML</a>]



##### `provenance` Value Example  

```
{
   "description" : "Original GA4GH schema",
   "id" : "https://github.com/ga4gh/ga4gh-schemas/blob/master/src/main/proto/ga4gh/bio_metadata.proto#L111"
}
```
    
#### sb_status

* type: string



##### `sb_status` Value Examples  

```
"core"
```
```
"implementation"
```
```
"proposed"
```
```
"playground"
```
    
#### use_cases

* type: array of https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.yaml" target="_BLANK">SRC</a>] [<a href="https://schemablocks.org/schemas/ga4gh/ExternalReference.html" target="_BLANK">HTML</a>]



##### `use_cases` Value Examples  

```
{
   "description" : "Phenopackets",
   "id" : "https://github.com/phenopackets/phenopacket-schema/blob/master/docs/age.rst"
}
```
```
{
   "description" : "Progenetix database schema (Beacon+ backend)",
   "id" : "https://github.com/progenetix/schemas/tree/master/main/yaml"
}
```

### `BlockMeta` Value Example  

```
{
   "contributors" : [
      {
         "description" : "Michael Baudis",
         "id" : "orcid:0000-0002-9903-4248"
      },
      {
         "description" : "Ben Hutton",
         "id" : "https://github.com/Relequestual"
      }
   ],
   "provenance" : [
      {
         "description" : "Developer branch of original GA4GH schema",
         "id" : "https://github.com/ga4gh-metadata/metadata-schemas/blob/master/schemas/shared.proto#L60"
      }
   ],
   "sb_status" : "playground",
   "used_by" : [
      {
         "description" : "Phenopackets",
         "id" : "https://github.com/phenopackets/phenopacket-schema/blob/master/docs/geolocation.rst"
      },
      {
         "description" : "Progenetix database schema (Beacon+ backend)",
         "id" : "https://github.com/progenetix/schemas/tree/master/main/yaml"
      }
   ]
}
```
    
#### Source

* [raw data](./BlockMeta.yaml)
* [Github](https://github.com/ga4gh-schemablocks/blocks/blob/master/src/yaml/BlockMeta.yaml)


