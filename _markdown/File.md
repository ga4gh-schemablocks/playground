
## File

### SchemaBlocks Metadata

* {S}[B] Status  [[i]](https://schemablocks.org/about/sb-status-levels.html)
    - __implemented__


* Provenance  

    - [Phenopackets](https://github.com/phenopackets/phenopacket-schema/blob/master/docs/file.rst)  

* Used by  

    - [Phenopackets](https://github.com/phenopackets/phenopacket-schema/blob/master/docs/file.rst)  

* Contributors  

    - [Jules Jacobsen](https://orcid.org/0000-0002-3265-15918)  
<!--more-->

### Source

* raw source [[YAML](./File.yaml)] [[JSON](./File.json)] 
* [Github](https://github.com/ga4gh-schemablocks/playground/blob/master/sb-meta/File.yaml)

### Attributes

* Type: 
    - object

### Properties

<table>
  <tr>
    <th>Property</th>
    <th>Type</th>
  </tr>
  <tr>
    <td>description</td>
    <td>string</td>
  </tr>
  <tr>
    <td>path</td>
    <td>string</td>
  </tr>
  <tr>
    <td>uri</td>
    <td>string</td>
  </tr>

</table>

    
#### description

* type: string

description of the file contents

##### `description` Value Example  

```
"file of project x"
```
    
#### path

* type: string

Full system path to the file

##### `path` Value Example  

```
"/data/genomes/file1.vcf.gz"
```
    
#### uri

* type: string

URI for the file

##### `uri` Value Examples  

```
"file://data/genomes/file1.vcf.gz"
```
```
"https://opensnp.org/data/60.23andme-exome-vcf.231?1341012444"
```


### `File` Value Example  

```
{
   "description" : "file of project x",
   "path" : "/data/genomes/file1.vcf.gz",
   "uri" : "file://data/genomes/file1.vcf.gz"
}
```

