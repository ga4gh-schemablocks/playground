
## Age

### SchemaBlocks Metadata

* {S}[B] Status  [[i]](https://schemablocks.org/about/sb-status-levels.html)
    - __implemented__


* Provenance  

    - [Phenopackets](https://github.com/phenopackets/phenopacket-schema/blob/master/docs/age.rst)  

* Used by  

    - [Phenopackets](https://github.com/phenopackets/phenopacket-schema/blob/master/docs/age.rst)  

* Contributors  

    - [Jules Jacobsen](https://orcid.org/0000-0002-3265-15918)  
    - [Peter Robinson](https://orcid.org/0000-0002-0736-91998)  
    - [Michael Baudis](https://orcid.org/0000-0002-9903-4248)  
<!--more-->

### Properties

<table>
  <tr>
    <th>Property</th>
    <th>Type</th>
  </tr>
  <tr>
    <td>age</td>
    <td>string</td>
  </tr>
  <tr>
    <td>ageClass</td>
    <td>https://schemablocks.org/schemas/ga4gh/OntologyClass.yaml [<a href="https://schemablocks.org/schemas/ga4gh/OntologyClass.yaml" target="_BLANK">SRC</a>] [<a href="https://schemablocks.org/schemas/ga4gh/OntologyClass.html" target="_BLANK">HTML</a>]</td>
  </tr>

</table>

    
#### age

* type: string



##### `age` Value Example  

```
"P12Y"
```
    
#### ageClass

* type: https://schemablocks.org/schemas/ga4gh/OntologyClass.yaml [<a href="https://schemablocks.org/schemas/ga4gh/OntologyClass.yaml" target="_BLANK">SRC</a>] [<a href="https://schemablocks.org/schemas/ga4gh/OntologyClass.html" target="_BLANK">HTML</a>]



##### `ageClass` Value Example  

```
{
   "id" : "HsapDv:0000083",
   "label" : "infant stage"
}
```

### `Age` Value Examples  

```
{
   "age" : "P14Y",
   "ageClass" : {
      "id" : "HsapDv:0000086",
      "label" : "adolescent stage"
   }
}
```
```
{
   "age" : "P56Y3M"
}
```
    
#### Source

* [raw data](./Age.yaml)
* [Github](https://github.com/ga4gh-schemablocks/blocks/blob/master/src/yaml/Age.yaml)


