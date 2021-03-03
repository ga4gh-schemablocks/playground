
<div id="schema-header-title">
  <h2>GeoLabels <span id="schema-header-title-project">playground <a href="https://github.com/ga4gh-schemablocks/playground" target="_BLANK">&nearr;</a></span> </h2>
</div>

<table id="schema-header-table">
  <tr>
    <th>{S}[B] Status <a href="https://schemablocks.org/about/sb-status-levels.html">[i]</a></th>
    <td><div id="schema-header-status">proposed</div></td>
  </tr>

  <tr>
    <th>Provenance</th>
    <td>
      <ul>
<li><a href="https://github.com/ga4gh-metadata/metadata-schemas/blob/master/schemas/shared.proto#L60">Developer branch of original GA4GH schema</a></li>
<li><a href="https://github.com/progenetix/schemas/">Progenetix</a></li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>Used by</th>
    <td>
      <ul>
<li><a href="https://github.com/progenetix/schemas/">Progenetix database schema (Beacon+ backend)</a></li>
      </ul>
    </td>
  </tr>

<!--more-->

  <tr>
    <th>Contributors</th>
    <td>
      <ul>
<li>GA4GH Metadata Task Team</li>
<li><a href="https://orcid.org/0000-0002-9903-4248">Michael Baudis</a></li>
<li><a href="https://orcid.org/0000-0002-4839-5158">Isuru Liyanage</a></li>
<li><a href="https://orcid.org/0000-0002-9551-6370">Melanie Courtot</a></li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>Source (v2022-03-03)</th>
    <td>
      <ul>
        <li><a href="current/GeoLabels.json" target="_BLANK">raw source [JSON]</a></li>
        <li><a href="https://github.com/ga4gh-schemablocks/playground/blob/master/schemas/GeoLabels.yaml" target="_BLANK">Github</a></li>
      </ul>
    </td>
  </tr>
</table>

<div id="schema-attributes-title">
  <h3>Attributes</h3>
</div>

  
__Description:__ GeoLabels represent an instance of the GeoJSON `properties` object. The parameters provide additional information for the interpretation of the location parameters, and also serve for optional "sanity checks" off the corresponding latitude, longitude (, altitude).

