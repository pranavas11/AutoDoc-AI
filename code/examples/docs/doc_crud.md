**CRUD Operations**

The CRUD (Create, Read, Update, Delete) class provides a set of methods for managing items in a collection. The following documentation outlines the available operations and their respective inputs, outputs, and potential errors.

### Create Item

#### METHOD `create_item`

Creates a new item with the provided ID, name, and optional description, and adds it to the collection.

### Input

* `id`: A unique identifier for the item (int or str)
* `name`: The name of the item (str)
* `description`: An optional brief description of the item (str)

Example:

```json
{
  "id": 1,
  "name": "Item 1",
  "description": "This is a sample item"
}
```

### Output

The newly created and added item object.

Example:

```json
Item(id=1, name='Item 1', description='This is a sample item')
```

### Error

* `ValueError`: If an item with the same ID already exists in the collection.

### Read Item

#### METHOD `read_item`

Retrieves an item from the collection by its unique identifier.

### Input

* `id`: The unique identifier of the item to be retrieved (int or str)

Example:

```json
{
  "id": 1
}
```

### Output

The item with the matching ID, or None if no match is found.

Example:

```json
Item(id=1, name='Item 1', description='This is a sample item')
```

### Error

* `ValueError`: If the input ID does not match any item in the collection.

### Update Item

#### METHOD `update_item`

Updates an item in the collection by its ID.

### Input

* `id`: The unique identifier of the item to be updated (int or str)
* `name`: An optional new name for the item (str)
* `description`: An optional new description for the item (str)

Example:

```json
{
  "id": 1,
  "name": "Updated Item",
  "description": "This is an updated description"
}
```

### Output

The updated item if found, or None if not found in the collection.

Example:

```json
Item(id=1, name='Updated Item', description='This is an updated description')
```

### Error

* `ValueError`: If the ID does not match any item in the collection.

### Delete Item

#### METHOD `delete_item`

