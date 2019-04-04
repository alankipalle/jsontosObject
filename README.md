# JSON Object Mapping for Apex

Utility classes to map between SObjects and the Map<String, Object> structures that you typically get from `JSON.deserializeUntyped()`.

Most field types are handled sensibly, but you can use your own classes implementing `Function` to do more complicated mapping e.g. for taking a currency value stored as pounds in Salesforce and multiplying by 100 to make it pennies in the resulting JSON map. 

The JSON objects don't have to be flat, they can include deeply nested structures

##JSON to SObject Example

With a JSON Object like this:

    { "meta": { "account" { "name": "ACME" } } }


We could construct a parser into a standard account object like this:

    JsonObjectToSObject parser = new JsonObjectToSObject(Account.SObjectType)
                .setObjectFieldToSObjectField(new Map<String, String> {'meta.Account.Name' => 'Name'});
    Account result = (Account)parser.toSObject(jsonString);
    
##SObject to JSON Example

If we convert a Contact into a JSON object like this:

    { "first_name": "John", "last_name": "Doe" }

Then we could construct a converter like this:

    SObjectToJsonObject converter = new SObjectToJsonObject(
        new Map<String, String> {
            'FirstName' => 'first_name', 
            'LastName' => 'last_name'
    });
    
    Map<String, Object> result = converter.toJsonObject(new Contact(FirstName = 'John', LastName = 'Doe'));

##More Examples

See the test classes for comprehensive examples of usage.  