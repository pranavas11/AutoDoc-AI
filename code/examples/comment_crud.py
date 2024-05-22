class Item:
    def __init__(self, id, name, description=None):
        self.id = id
        self.name = name
        self.description = description

    def __repr__(self):
        """
        Returns a string representation of this object.
        
        This method returns a string that represents the object in a human-readable format.
        The returned string includes the object's ID, name, and description.
        
        Args:
            self: The object itself (required)
        
        Returns:
            str: A string representation of the object
        
        Notes:
            This method is intended to be used for debugging purposes or when you need to display the object in a human-readable format.
        """

        return f"Item(id={self.id}, name={self.name}, description={self.description})"

class CRUD:
    def __init__(self):
        """
        Initializes an instance of the class.
        
        This method sets up the internal state of the object by creating an empty list to store items.
        
        Args:
            None: This method does not take any arguments.
        
        Returns:
            None: The method returns None, as it only initializes the object's state and does not perform any computations or return values.
        
        Raises:
            None: This method does not raise any exceptions.
        """

        self.items = []

    def create_item(self, id, name, description=None):
        """
        Creates and adds an item to the collection.
        
        This method creates a new Item object with the provided ID, name, and optional description. The created item is then added to the internal list of items.
        
        Args:
            self (object): The instance of the class that this method belongs to.
            id (int or str): A unique identifier for the item.
            name (str): The name of the item.
            description (str, optional): A brief description of the item. Defaults to None if not provided.
        
        Returns:
            Item: The newly created and added item object.
        
        Raises:
            ValueError: If an item with the same ID already exists in the collection.
        """

        item = Item(id, name, description)
        self.items.append(item)
        return item

    def read_item(self, id):
        """
        Retrieves an item from the collection by its unique identifier.
        
        This method iterates through the internal list of items and returns the first item that matches the given ID. If no matching item is found, it returns None.
        
        Args:
            self (object): The instance of the class containing this method.
            id (int or str): The unique identifier of the item to be retrieved.
        
        Returns:
            object: The item with the matching ID, or None if no match is found.
        
        Raises:
            ValueError: If the input ID does not match any item in the collection.
        """

        for item in self.items:
            if item.id == id:
                return item
        return None

    def update_item(self, id, name=None, description=None):
        """
        Updates an item in the collection by its ID.
        
        This method iterates through the items in the collection and updates the item with the matching ID. If provided, it updates the item's name or description accordingly.
        
        Args:
            self (object): The object instance that this method is called on.
            id (int): The unique identifier of the item to be updated.
            name (str, optional): The new name for the item. Defaults to None.
            description (str, optional): The new description for the item. Defaults to None.
        
        Returns:
            object: The updated item if found, or None if not found in the collection.
        
        Raises:
            ValueError: If the ID does not match any item in the collection.
        """

        for item in self.items:
            if item.id == id:
                if name:
                    item.name = name
                if description:
                    item.description = description
                return item
        return None

    def delete_item(self, id):
        """
        Deletes an item from the collection by its unique identifier.
        
        This method iterates through the items in the collection and removes the first item that matches the given ID. If no matching item is found, it returns None.
        
        Args:
            self (object): The object instance of the class containing this method.
            id (int or str): The unique identifier of the item to be deleted. This value should be a string or integer type that represents the ID of the item in the collection.
        
        Returns:
            object: The deleted item, if found; otherwise, None.
        
        Raises:
            ValueError: If no matching item is found with the given ID.
        """

        for index, item in enumerate(self.items):
            if item.id == id:
                return self.items.pop(index)
        return None

    def list_items(self):
        """
        Returns a list of items.
        
        This method returns the internal list of items stored in the object.
        
        Arguments:
            None: This method does not take any arguments.
        
        Returns:
            list: A list of items, which is the internal state of the object.
        
        Raises:
            None: This method does not raise any exceptions.
        """

        return self.items