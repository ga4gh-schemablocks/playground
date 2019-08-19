## Age

### SchemaBlocks Metadata

##### Provenance  

* [Phenopackets](https://github.com/phenopackets/phenopacket-schema/blob/master/docs/age.rst)  

##### Used by  

* [Phenopackets](https://github.com/phenopackets/phenopacket-schema/blob/master/docs/age.rst)  

##### Contributors  

* [Jules Jacobsen](https://orcid.org/0000-0002-3265-15918)  
* [Peter Robinson](https://orcid.org/0000-0002-0736-91998)  
* [Michael Baudis](https://orcid.org/0000-0002-9903-4248)  

##### {S}[B] Status  [[i]](https://schemablocks.org/about/sb-status-levels.html)

* __implemented__  

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
    <td></td>
  </tr>

</table>

    
#### age

* type: string

Age as ISO8601 period

##### `age` Value Example  

```
"P12Y"
```
    
#### ageClass

* type: 

The age of the subject (e.g. individual at the onset of a phenotype),
as OntologyClass. An example ontology here is HsapDv (Human
Developmental Stages).
This does not exactly correspond to the use of "age of onset" in HPO,
since this specifically codes the "onset" of a phenotype, not just any
age as a timepoint. So when coding onset, implementations may choose
to either use an "age of onset" ontology or an "Age" class.


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
