// Sample Recipes Data
const sampleRecipes = [
  {
    id: 'r1',
    title: 'Mediterranean Chickpea Salad',
    description: 'A refreshing salad with chickpeas, cucumber, tomatoes, and feta cheese, dressed with lemon and olive oil.',
    image: 'https://source.unsplash.com/random/300x200/?chickpea-salad',
    prepTime: 15,
    cookTime: 0,
    servings: 4,
    calories: 320,
    difficulty: 'Easy',
    category: 'lunch',
    rating: 4.8,
    featured: true,
    tags: ['vegetarian', 'salad', 'lunch', 'mediterranean', 'quick'],
    ingredients: [
      { name: 'chickpeas', quantity: '1', unit: 'can (15 oz)', category: 'Canned Goods' },
      { name: 'cucumber', quantity: '1', unit: 'medium', category: 'Produce' },
      { name: 'cherry tomatoes', quantity: '1', unit: 'cup', category: 'Produce' },
      { name: 'red onion', quantity: '1/4', unit: 'cup', category: 'Produce' },
      { name: 'feta cheese', quantity: '1/2', unit: 'cup', category: 'Dairy' },
      { name: 'kalamata olives', quantity: '1/4', unit: 'cup', category: 'Canned Goods' },
      { name: 'fresh parsley', quantity: '1/4', unit: 'cup', category: 'Produce' },
      { name: 'olive oil', quantity: '3', unit: 'tbsp', category: 'Condiments' },
      { name: 'lemon juice', quantity: '2', unit: 'tbsp', category: 'Produce' },
      { name: 'garlic', quantity: '1', unit: 'clove', category: 'Produce' },
      { name: 'salt', quantity: '1/2', unit: 'tsp', category: 'Spices' },
      { name: 'black pepper', quantity: '1/4', unit: 'tsp', category: 'Spices' }
    ],
    instructions: [
      { 
        title: 'Prepare Vegetables', 
        description: 'Dice cucumber, halve cherry tomatoes, and finely chop red onion and parsley.'
      },
      { 
        title: 'Mix Dressing', 
        description: 'In a small bowl, whisk together olive oil, lemon juice, minced garlic, salt, and pepper.'
      },
      { 
        title: 'Combine Ingredients', 
        description: 'In a large bowl, combine chickpeas, prepared vegetables, olives, and feta cheese.'
      },
      { 
        title: 'Add Dressing', 
        description: 'Pour dressing over salad and toss to combine. Garnish with additional parsley if desired.'
      }
    ],
    notes: [
      'For meal prep, keep the dressing separate until ready to serve.',
      'Add grilled chicken or shrimp for extra protein.',
      'Can be stored in the refrigerator for up to 3 days.'
    ],
    nutrition: {
      calories: '320 kcal',
      protein: '12g',
      carbs: '32g',
      fat: '18g',
      fiber: '8g'
    }
  },
  {
    id: 'r2',
    title: 'One-Pot Creamy Chicken Pasta',
    description: 'A simple and delicious pasta dish made with tender chicken, creamy sauce, and fresh spinach, all in one pot!',
    image: 'https://source.unsplash.com/random/300x200/?chicken-pasta',
    prepTime: 10,
    cookTime: 25,
    servings: 4,
    calories: 520,
    difficulty: 'Medium',
    category: 'dinner',
    rating: 4.7,
    featured: true,
    tags: ['dinner', 'pasta', 'chicken', 'one-pot'],
    ingredients: [
      { name: 'boneless chicken breast', quantity: '1', unit: 'lb', category: 'Meat' },
      { name: 'fettuccine pasta', quantity: '8', unit: 'oz', category: 'Dry Goods' },
      { name: 'garlic', quantity: '3', unit: 'cloves', category: 'Produce' },
      { name: 'chicken broth', quantity: '2', unit: 'cups', category: 'Canned Goods' },
      { name: 'heavy cream', quantity: '1', unit: 'cup', category: 'Dairy' },
      { name: 'parmesan cheese', quantity: '1/2', unit: 'cup', category: 'Dairy' },
      { name: 'fresh spinach', quantity: '3', unit: 'cups', category: 'Produce' },
      { name: 'olive oil', quantity: '2', unit: 'tbsp', category: 'Condiments' },
      { name: 'Italian seasoning', quantity: '1', unit: 'tsp', category: 'Spices' },
      { name: 'salt', quantity: '1/2', unit: 'tsp', category: 'Spices' },
      { name: 'black pepper', quantity: '1/4', unit: 'tsp', category: 'Spices' },
      { name: 'red pepper flakes', quantity: '1/4', unit: 'tsp', category: 'Spices' }
    ],
    instructions: [
      { 
        title: 'Prepare Chicken', 
        description: 'Cut chicken into 1-inch pieces. Season with salt and pepper.'
      },
      { 
        title: 'Sauté Chicken', 
        description: 'Heat olive oil in a large pot over medium heat. Add chicken and cook until golden, about 5-6 minutes. Add garlic and cook for 30 seconds.'
      },
      { 
        title: 'Add Liquids and Pasta', 
        description: 'Add chicken broth, heavy cream, and Italian seasoning. Bring to a simmer. Add pasta and ensure it\'s fully submerged.'
      },
      { 
        title: 'Cook Pasta', 
        description: 'Cover and cook for 10-12 minutes, stirring occasionally, until pasta is al dente and sauce has thickened.'
      },
      { 
        title: 'Add Spinach and Cheese', 
        description: 'Stir in spinach and cook until wilted. Remove from heat and stir in parmesan cheese. Season with additional salt and pepper if needed.'
      }
    ],
    notes: [
      'For a lighter version, substitute half-and-half for the heavy cream.',
      'Add mushrooms or sun-dried tomatoes for extra flavor.',
      'Sprinkle with fresh basil before serving for a pop of color and flavor.'
    ],
    nutrition: {
      calories: '520 kcal',
      protein: '35g',
      carbs: '38g',
      fat: '26g',
      fiber: '3g'
    }
  },
  {
    id: 'r3',
    title: 'Berry Banana Smoothie Bowl',
    description: 'A delicious and nutritious breakfast bowl packed with mixed berries, banana, and topped with granola and nuts.',
    image: 'https://source.unsplash.com/random/300x200/?smoothie-bowl',
    prepTime: 5,
    cookTime: 0,
    servings: 1,
    calories: 320,
    difficulty: 'Easy',
    category: 'breakfast',
    rating: 4.9,
    featured: true,
    tags: ['breakfast', 'vegetarian', 'smoothie', 'quick', 'gluten-free'],
    ingredients: [
      { name: 'frozen mixed berries', quantity: '1', unit: 'cup', category: 'Frozen' },
      { name: 'banana', quantity: '1', unit: 'medium', category: 'Produce' },
      { name: 'Greek yogurt', quantity: '1/2', unit: 'cup', category: 'Dairy' },
      { name: 'almond milk', quantity: '1/4', unit: 'cup', category: 'Dairy' },
      { name: 'honey', quantity: '1', unit: 'tbsp', category: 'Condiments' },
      { name: 'granola', quantity: '1/4', unit: 'cup', category: 'Dry Goods' },
      { name: 'sliced almonds', quantity: '1', unit: 'tbsp', category: 'Dry Goods' },
      { name: 'chia seeds', quantity: '1', unit: 'tsp', category: 'Dry Goods' },
      { name: 'fresh berries', quantity: '1/4', unit: 'cup', category: 'Produce' }
    ],
    instructions: [
      { 
        title: 'Blend Base', 
        description: 'In a blender, combine frozen berries, banana, Greek yogurt, almond milk, and honey. Blend until smooth and thick.'
      },
      { 
        title: 'Transfer to Bowl', 
        description: 'Pour the smoothie mixture into a bowl. It should be thick enough to eat with a spoon.'
      },
      { 
        title: 'Add Toppings', 
        description: 'Top with granola, sliced almonds, chia seeds, and fresh berries.'
      }
    ],
    notes: [
      'For a vegan version, use coconut yogurt instead of Greek yogurt.',
      'Add a scoop of protein powder for extra protein.',
      'Freeze the banana for an extra thick and cold smoothie bowl.'
    ],
    nutrition: {
      calories: '320 kcal',
      protein: '12g',
      carbs: '58g',
      fat: '8g',
      fiber: '10g'
    }
  },
  {
    id: 'r4',
    title: 'Sheet Pan Salmon with Roasted Vegetables',
    description: 'A simple and healthy dinner with salmon fillets and colorful vegetables, all roasted on one sheet pan.',
    image: 'https://source.unsplash.com/random/300x200/?salmon',
    prepTime: 15,
    cookTime: 20,
    servings: 4,
    calories: 410,
    difficulty: 'Easy',
    category: 'dinner',
    rating: 4.6,
    featured: false,
    tags: ['dinner', 'seafood', 'gluten-free', 'low-carb', 'sheet-pan'],
    ingredients: [
      { name: 'salmon fillets', quantity: '4', unit: 'pieces (6 oz each)', category: 'Meat' },
      { name: 'broccoli florets', quantity: '2', unit: 'cups', category: 'Produce' },
      { name: 'bell peppers', quantity: '2', unit: 'medium', category: 'Produce' },
      { name: 'red onion', quantity: '1', unit: 'medium', category: 'Produce' },
      { name: 'cherry tomatoes', quantity: '1', unit: 'cup', category: 'Produce' },
      { name: 'olive oil', quantity: '3', unit: 'tbsp', category: 'Condiments' },
      { name: 'lemon', quantity: '1', unit: 'medium', category: 'Produce' },
      { name: 'garlic', quantity: '3', unit: 'cloves', category: 'Produce' },
      { name: 'dried oregano', quantity: '1', unit: 'tsp', category: 'Spices' },
      { name: 'dried thyme', quantity: '1/2', unit: 'tsp', category: 'Spices' },
      { name: 'salt', quantity: '1', unit: 'tsp', category: 'Spices' },
      { name: 'black pepper', quantity: '1/2', unit: 'tsp', category: 'Spices' }
    ],
    instructions: [
      { 
        title: 'Preheat Oven', 
        description: 'Preheat oven to 400°F (200°C) and line a large baking sheet with parchment paper.'
      },
      { 
        title: 'Prepare Vegetables', 
        description: 'Cut broccoli into florets, slice bell peppers, and cut red onion into wedges. Place all vegetables including cherry tomatoes on the baking sheet.'
      },
      { 
        title: 'Season Vegetables', 
        description: 'Drizzle vegetables with 2 tablespoons olive oil, minced garlic, half of the herbs, and half of the salt and pepper. Toss to coat.'
      },
      { 
        title: 'Roast Vegetables', 
        description: 'Roast vegetables in the preheated oven for 10 minutes.'
      },
      { 
        title: 'Prepare Salmon', 
        description: 'Meanwhile, pat salmon fillets dry with paper towels. Drizzle with remaining olive oil and season with remaining herbs, salt, and pepper.'
      },
      { 
        title: 'Add Salmon to Sheet Pan', 
        description: 'Remove sheet pan from oven, push vegetables to the sides to make room for the salmon. Place salmon skin-side down on the sheet pan.'
      },
      { 
        title: 'Finish Roasting', 
        description: 'Return to oven and roast for an additional 12-15 minutes, or until salmon is cooked through and vegetables are tender.'
      },
      { 
        title: 'Serve', 
        description: 'Squeeze fresh lemon juice over everything before serving.'
      }
    ],
    notes: [
      'Try to cut vegetables into similar sizes for even cooking.',
      'For a spicier version, add a pinch of red pepper flakes.',
      'Leftovers can be stored in the refrigerator for up to 2 days.'
    ],
    nutrition: {
      calories: '410 kcal',
      protein: '32g',
      carbs: '15g',
      fat: '25g',
      fiber: '5g'
    }
  },
  {
    id: 'r5',
    title: 'Vegetarian Chili',
    description: 'A hearty and flavorful vegetarian chili packed with beans, vegetables, and warming spices.',
    image: 'https://source.unsplash.com/random/300x200/?vegetarian-chili',
    prepTime: 15,
    cookTime: 45,
    servings: 6,
    calories: 350,
    difficulty: 'Medium',
    category: 'dinner',
    rating: 4.5,
    featured: true,
    tags: ['vegetarian', 'dinner', 'lunch', 'beans', 'gluten-free'],
    ingredients: [
      { name: 'olive oil', quantity: '2', unit: 'tbsp', category: 'Condiments' },
      { name: 'onion', quantity: '1', unit: 'large', category: 'Produce' },
      { name: 'bell peppers', quantity: '2', unit: 'medium', category: 'Produce' },
      { name: 'carrots', quantity: '2', unit: 'medium', category: 'Produce' },
      { name: 'celery stalks', quantity: '2', unit: 'medium', category: 'Produce' },
      { name: 'garlic', quantity: '4', unit: 'cloves', category: 'Produce' },
      { name: 'chili powder', quantity: '2', unit: 'tbsp', category: 'Spices' },
      { name: 'cumin', quantity: '1', unit: 'tbsp', category: 'Spices' },
      { name: 'smoked paprika', quantity: '1', unit: 'tsp', category: 'Spices' },
      { name: 'oregano', quantity: '1', unit: 'tsp', category: 'Spices' },
      { name: 'black beans', quantity: '2', unit: 'cans (15 oz each)', category: 'Canned Goods' },
      { name: 'kidney beans', quantity: '1', unit: 'can (15 oz)', category: 'Canned Goods' },
      { name: 'diced tomatoes', quantity: '2', unit: 'cans (14.5 oz each)', category: 'Canned Goods' },
      { name: 'tomato paste', quantity: '2', unit: 'tbsp', category: 'Canned Goods' },
      { name: 'vegetable broth', quantity: '2', unit: 'cups', category: 'Canned Goods' },
      { name: 'corn kernels', quantity: '1', unit: 'cup', category: 'Frozen' },
      { name: 'salt', quantity: '1', unit: 'tsp', category: 'Spices' },
      { name: 'black pepper', quantity: '1/2', unit: 'tsp', category: 'Spices' }
    ],
    instructions: [
      { 
        title: 'Sauté Vegetables', 
        description: 'Heat olive oil in a large pot over medium heat. Add onion, bell peppers, carrots, and celery. Cook for 5-7 minutes until softened.'
      },
      { 
        title: 'Add Garlic and Spices', 
        description: 'Add minced garlic, chili powder, cumin, smoked paprika, and oregano. Cook for 1 minute until fragrant.'
      },
      { 
        title: 'Add Beans and Tomatoes', 
        description: 'Add black beans, kidney beans, diced tomatoes, tomato paste, and vegetable broth. Stir to combine.'
      },
      { 
        title: 'Simmer', 
        description: 'Bring to a boil, then reduce heat and simmer, partially covered, for 30 minutes, stirring occasionally.'
      },
      { 
        title: 'Add Corn', 
        description: 'Stir in corn kernels and cook for an additional 5 minutes. Season with salt and pepper to taste.'
      }
    ],
    notes: [
      'Serve with toppings like diced avocado, cilantro, shredded cheese, or sour cream.',
      'For a spicier chili, add a diced jalapeño or a pinch of cayenne pepper.',
      'Freezes well for up to 3 months.'
    ],
    nutrition: {
      calories: '350 kcal',
      protein: '15g',
      carbs: '58g',
      fat: '8g',
      fiber: '16g'
    }
  },
  {
    id: 'r6',
    title: 'Classic Pancakes',
    description: 'Fluffy, golden pancakes perfect for a weekend breakfast treat.',
    image: 'https://source.unsplash.com/random/300x200/?pancakes',
    prepTime: 10,
    cookTime: 15,
    servings: 4,
    calories: 280,
    difficulty: 'Easy',
    category: 'breakfast',
    rating: 4.8,
    featured: false,
    tags: ['breakfast', 'vegetarian', 'quick'],
    ingredients: [
      { name: 'all-purpose flour', quantity: '1 1/2', unit: 'cups', category: 'Dry Goods' },
      { name: 'baking powder', quantity: '3 1/2', unit: 'tsp', category: 'Dry Goods' },
      { name: 'salt', quantity: '1', unit: 'tsp', category: 'Spices' },
      { name: 'sugar', quantity: '1', unit: 'tbsp', category: 'Dry Goods' },
      { name: 'milk', quantity: '1 1/4', unit: 'cups', category: 'Dairy' },
      { name: 'egg', quantity: '1', unit: 'large', category: 'Dairy' },
      { name: 'butter', quantity: '3', unit: 'tbsp', category: 'Dairy' },
      { name: 'vanilla extract', quantity: '1', unit: 'tsp', category: 'Condiments' },
      { name: 'maple syrup', quantity: '1/4', unit: 'cup', category: 'Condiments' },
      { name: 'fresh berries', quantity: '1', unit: 'cup', category: 'Produce' }
    ],
    instructions: [
      { 
        title: 'Mix Dry Ingredients', 
        description: 'In a large bowl, whisk together flour, baking powder, salt, and sugar.'
      },
      { 
        title: 'Mix Wet Ingredients', 
        description: 'In a separate bowl, whisk together milk, egg, melted butter, and vanilla extract.'
      },
      { 
        title: 'Combine Mixtures', 
        description: 'Pour the wet ingredients into the dry ingredients and stir until just combined. Don\'t overmix; small lumps are okay.'
      },
      { 
        title: 'Cook Pancakes', 
        description: 'Heat a lightly oiled griddle or frying pan over medium-high heat. Pour 1/4 cup batter onto the griddle for each pancake. Cook until bubbles form on the surface, then flip and cook until golden brown on both sides.'
      },
      { 
        title: 'Serve', 
        description: 'Serve hot with maple syrup and fresh berries.'
      }
    ],
    notes: [
      'For extra fluffy pancakes, let the batter rest for 5 minutes before cooking.',
      'Add chocolate chips, blueberries, or sliced bananas to the batter for variety.',
      'Keep pancakes warm in a 200°F oven while cooking the remaining batches.'
    ],
    nutrition: {
      calories: '280 kcal',
      protein: '7g',
      carbs: '42g',
      fat: '10g',
      fiber: '1g'
    }
  },
  {
    id: 'r7',
    title: 'Avocado Toast with Poached Egg',
    description: 'A simple yet satisfying breakfast or brunch option featuring creamy avocado and perfectly poached eggs on whole grain toast.',
    image: 'https://source.unsplash.com/random/300x200/?avocado-toast',
    prepTime: 10,
    cookTime: 5,
    servings: 2,
    calories: 310,
    difficulty: 'Medium',
    category: 'breakfast',
    rating: 4.7,
    featured: true,
    tags: ['breakfast', 'vegetarian', 'quick', 'healthy'],
    ingredients: [
      { name: 'whole grain bread', quantity: '2', unit: 'slices', category: 'Bakery' },
      { name: 'ripe avocado', quantity: '1', unit: 'medium', category: 'Produce' },
      { name: 'eggs', quantity: '2', unit: 'large', category: 'Dairy' },
      { name: 'white vinegar', quantity: '1', unit: 'tbsp', category: 'Condiments' },
      { name: 'cherry tomatoes', quantity: '1/2', unit: 'cup', category: 'Produce' },
      { name: 'red pepper flakes', quantity: '1/4', unit: 'tsp', category: 'Spices' },
      { name: 'fresh lemon juice', quantity: '1', unit: 'tsp', category: 'Produce' },
      { name: 'salt', quantity: '1/4', unit: 'tsp', category: 'Spices' },
      { name: 'black pepper', quantity: '1/4', unit: 'tsp', category: 'Spices' },
      { name: 'microgreens or fresh herbs', quantity: '2', unit: 'tbsp', category: 'Produce' }
    ],
    instructions: [
      { 
        title: 'Prepare Avocado', 
        description: 'Cut the avocado in half, remove the pit, and scoop the flesh into a bowl. Mash with a fork, adding lemon juice, salt, and pepper to taste.'
      },
      { 
        title: 'Toast Bread', 
        description: 'Toast the bread slices until golden brown and crispy.'
      },
      { 
        title: 'Poach Eggs', 
        description: 'Bring a pot of water to a gentle simmer. Add white vinegar. Create a vortex in the water with a spoon, then carefully crack an egg into the center. Cook for 3-4 minutes for a runny yolk. Remove with a slotted spoon. Repeat with the second egg.'
      },
      { 
        title: 'Assemble Toast', 
        description: 'Spread the mashed avocado on the toast slices. Top each with a poached egg. Slice cherry tomatoes in half and arrange on top.'
      },
      { 
        title: 'Garnish', 
        description: 'Sprinkle with red pepper flakes, additional salt and pepper, and microgreens or fresh herbs.'
      }
    ],
    notes: [
      'For perfect poached eggs, use the freshest eggs possible.',
      'Add a sprinkle of feta cheese or a drizzle of hot sauce for extra flavor.',
      'Swap the poached egg for scrambled tofu for a vegan version.'
    ],
    nutrition: {
      calories: '310 kcal',
      protein: '13g',
      carbs: '24g',
      fat: '18g',
      fiber: '8g'
    }
  },
  {
    id: 'r8',
    title: 'Homemade Margherita Pizza',
    description: 'A classic Italian pizza with a thin crust, fresh tomatoes, mozzarella cheese, and basil.',
    image: 'https://source.unsplash.com/random/300x200/?pizza',
    prepTime: 30,
    cookTime: 15,
    servings: 4,
    calories: 420,
    difficulty: 'Medium',
    category: 'dinner',
    rating: 4.9,
    featured: true,
    tags: ['dinner', 'vegetarian', 'italian'],
    ingredients: [
      { name: 'pizza dough', quantity: '1', unit: 'pound', category: 'Bakery' },
      { name: 'tomato sauce', quantity: '1/2', unit: 'cup', category: 'Canned Goods' },
      { name: 'fresh mozzarella cheese', quantity: '8', unit: 'oz', category: 'Dairy' },
      { name: 'fresh basil leaves', quantity: '1/4', unit: 'cup', category: 'Produce' },
      { name: 'cherry tomatoes', quantity: '1', unit: 'cup', category: 'Produce' },
      { name: 'olive oil', quantity: '2', unit: 'tbsp', category: 'Condiments' },
      { name: 'garlic', quantity: '2', unit: 'cloves', category: 'Produce' },
      { name: 'salt', quantity: '1/2', unit: 'tsp', category: 'Spices' },
      { name: 'red pepper flakes', quantity: '1/4', unit: 'tsp', category: 'Spices' },
      { name: 'cornmeal', quantity: '2', unit: 'tbsp', category: 'Dry Goods' }
    ],
    instructions: [
      { 
        title: 'Prepare Oven', 
        description: 'Preheat oven to 475°F (245°C). If you have a pizza stone, place it in the oven to heat.'
      },
      { 
        title: 'Prepare Dough', 
        description: 'Roll out the pizza dough on a floured surface to about 12-14 inches in diameter.'
      },
      { 
        title: 'Transfer to Baking Sheet', 
        description: 'Sprinkle cornmeal on a baking sheet or pizza peel. Transfer the rolled dough onto it.'
      },
      { 
        title: 'Add Sauce and Toppings', 
        description: 'Spread tomato sauce over the dough, leaving a 1-inch border. Tear mozzarella into pieces and distribute over the sauce. Slice cherry tomatoes in half and arrange on top.'
      },
      { 
        title: 'Bake', 
        description: 'Bake for 12-15 minutes, or until the crust is golden and the cheese is bubbly and slightly browned.'
      },
      { 
        title: 'Garnish', 
        description: 'Remove from oven and immediately top with fresh basil leaves, a drizzle of olive oil, and a sprinkle of salt and red pepper flakes.'
      }
    ],
    notes: [
      'For best results, use a pizza stone and preheat it in the oven.',
      'If making dough from scratch, allow it to rise properly for the best texture.',
      'Brush the crust edge with olive oil before baking for extra flavor and color.'
    ],
    nutrition: {
      calories: '420 kcal',
      protein: '18g',
      carbs: '52g',
      fat: '16g',
      fiber: '3g'
    }
  },
  {
    id: 'r9',
    title: 'Greek Yogurt Parfait',
    description: 'A layered breakfast treat with Greek yogurt, fresh berries, honey, and crunchy granola.',
    image: 'https://source.unsplash.com/random/300x200/?yogurt-parfait',
    prepTime: 10,
    cookTime: 0,
    servings: 2,
    calories: 290,
    difficulty: 'Easy',
    category: 'breakfast',
    rating: 4.5,
    featured: false,
    tags: ['breakfast', 'vegetarian', 'quick', 'healthy', 'no-cook'],
    ingredients: [
      { name: 'Greek yogurt', quantity: '2', unit: 'cups', category: 'Dairy' },
      { name: 'granola', quantity: '1/2', unit: 'cup', category: 'Dry Goods' },
      { name: 'mixed berries', quantity: '1', unit: 'cup', category: 'Produce' },
      { name: 'honey', quantity: '2', unit: 'tbsp', category: 'Condiments' },
      { name: 'sliced almonds', quantity: '2', unit: 'tbsp', category: 'Dry Goods' },
      { name: 'chia seeds', quantity: '1', unit: 'tbsp', category: 'Dry Goods' },
      { name: 'ground cinnamon', quantity: '1/4', unit: 'tsp', category: 'Spices' }
    ],
    instructions: [
      { 
        title: 'Prepare First Layer', 
        description: 'In two serving glasses or bowls, add a layer of Greek yogurt (about 1/4 cup in each).'
      },
      { 
        title: 'Add Berries', 
        description: 'Top with a layer of mixed berries (about 1/4 cup in each).'
      },
      { 
        title: 'Add Granola', 
        description: 'Sprinkle a layer of granola over the berries (about 2 tablespoons in each).'
      },
      { 
        title: 'Repeat Layers', 
        description: 'Repeat the layering process: yogurt, berries, granola.'
      },
      { 
        title: 'Add Toppings', 
        description: 'Drizzle with honey, and sprinkle with sliced almonds, chia seeds, and a dash of cinnamon.'
      }
    ],
    notes: [
      'Prepare the parfait just before serving to keep the granola crunchy.',
      'Use frozen berries that have been thawed if fresh aren\'t available.',
      'For a vegan option, use coconut yogurt and maple syrup instead of Greek yogurt and honey.'
    ],
    nutrition: {
      calories: '290 kcal',
      protein: '18g',
      carbs: '38g',
      fat: '9g',
      fiber: '5g'
    }
  },
  {
    id: 'r10',
    title: 'Beef and Broccoli Stir Fry',
    description: 'A quick and flavorful Asian-inspired dish with tender beef, crisp broccoli, and savory sauce.',
    image: 'https://source.unsplash.com/random/300x200/?beef-stir-fry',
    prepTime: 15,
    cookTime: 15,
    servings: 4,
    calories: 380,
    difficulty: 'Medium',
    category: 'dinner',
    rating: 4.6,
    featured: false,
    tags: ['dinner', 'beef', 'asian', 'quick'],
    ingredients: [
      { name: 'flank steak', quantity: '1', unit: 'lb', category: 'Meat' },
      { name: 'broccoli florets', quantity: '4', unit: 'cups', category: 'Produce' },
      { name: 'garlic', quantity: '3', unit: 'cloves', category: 'Produce' },
      { name: 'fresh ginger', quantity: '1', unit: 'tbsp', category: 'Produce' },
      { name: 'vegetable oil', quantity: '2', unit: 'tbsp', category: 'Condiments' },
      { name: 'sesame oil', quantity: '1', unit: 'tsp', category: 'Condiments' },
      { name: 'soy sauce', quantity: '1/4', unit: 'cup', category: 'Condiments' },
      { name: 'beef broth', quantity: '1/2', unit: 'cup', category: 'Canned Goods' },
      { name: 'brown sugar', quantity: '2', unit: 'tbsp', category: 'Dry Goods' },
      { name: 'cornstarch', quantity: '1', unit: 'tbsp', category: 'Dry Goods' },
      { name: 'red pepper flakes', quantity: '1/4', unit: 'tsp', category: 'Spices' },
      { name: 'green onions', quantity: '4', unit: 'stalks', category: 'Produce' },
      { name: 'sesame seeds', quantity: '1', unit: 'tbsp', category: 'Dry Goods' }
    ],
    instructions: [
      { 
        title: 'Prepare Beef', 
        description: 'Slice the flank steak against the grain into thin strips. Place in a bowl and toss with 1 tablespoon cornstarch, 1 tablespoon soy sauce, and 1 teaspoon sesame oil.'
      },
      { 
        title: 'Prepare Sauce', 
        description: 'In a small bowl, whisk together beef broth, remaining soy sauce, brown sugar, and cornstarch until smooth.'
      },
      { 
        title: 'Stir Fry Beef', 
        description: 'Heat 1 tablespoon vegetable oil in a large wok or skillet over high heat. Add beef in a single layer and cook without stirring for 1 minute. Stir and cook until browned, about 2 more minutes. Remove to a plate.'
      },
      { 
        title: 'Cook Broccoli', 
        description: 'Add remaining oil to the pan. Add broccoli and stir fry for 3 minutes. Add minced garlic, ginger, and red pepper flakes. Cook for 30 seconds until fragrant.'
      },
      { 
        title: 'Combine and Add Sauce', 
        description: 'Return beef to the pan with broccoli. Pour sauce over everything and stir to combine. Cook until sauce thickens, about 1-2 minutes.'
      },
      { 
        title: 'Garnish and Serve', 
        description: 'Sprinkle with sliced green onions and sesame seeds before serving. Serve hot with rice if desired.'
      }
    ],
    notes: [
      'Freeze the beef for 15-20 minutes before slicing to make it easier to cut thin.',
      'For extra tender beef, marinate it for up to 4 hours before cooking.',
      'Add other vegetables like bell peppers, carrots, or mushrooms for variety.'
    ],
    nutrition: {
      calories: '380 kcal',
      protein: '30g',
      carbs: '18g',
      fat: '22g',
      fiber: '4g'
    }
  },
  {
    id: 'r11',
    title: 'Homemade Chocolate Chip Cookies',
    description: 'Classic soft and chewy chocolate chip cookies with a perfect balance of sweet and salty flavors.',
    image: 'https://source.unsplash.com/random/300x200/?chocolate-chip-cookies',
    prepTime: 15,
    cookTime: 12,
    servings: 24,
    calories: 180,
    difficulty: 'Easy',
    category: 'desserts',
    rating: 4.9,
    featured: true,
    tags: ['dessert', 'baking', 'vegetarian', 'cookies'],
    ingredients: [
      { name: 'all-purpose flour', quantity: '2 1/4', unit: 'cups', category: 'Dry Goods' },
      { name: 'baking soda', quantity: '1', unit: 'tsp', category: 'Dry Goods' },
      { name: 'salt', quantity: '1', unit: 'tsp', category: 'Spices' },
      { name: 'unsalted butter', quantity: '1', unit: 'cup', category: 'Dairy' },
      { name: 'brown sugar', quantity: '3/4', unit: 'cup', category: 'Dry Goods' },
      { name: 'granulated sugar', quantity: '3/4', unit: 'cup', category: 'Dry Goods' },
      { name: 'vanilla extract', quantity: '1', unit: 'tsp', category: 'Condiments' },
      { name: 'eggs', quantity: '2', unit: 'large', category: 'Dairy' },
      { name: 'semi-sweet chocolate chips', quantity: '2', unit: 'cups', category: 'Dry Goods' },
      { name: 'walnuts', quantity: '1', unit: 'cup', category: 'Dry Goods' }
    ],
    instructions: [
      { 
        title: 'Prepare Oven', 
        description: 'Preheat oven to 375°F (190°C). Line baking sheets with parchment paper.'
      },
      { 
        title: 'Mix Dry Ingredients', 
        description: 'In a medium bowl, whisk together flour, baking soda, and salt.'
      },
      { 
        title: 'Cream Butter and Sugars', 
        description: 'In a large bowl, beat butter, brown sugar, and granulated sugar until creamy and light, about 2-3 minutes.'
      },
      { 
        title: 'Add Eggs and Vanilla', 
        description: 'Beat in vanilla extract and eggs, one at a time, until well incorporated.'
      },
      { 
        title: 'Combine Mixtures', 
        description: 'Gradually add the flour mixture to the butter mixture, mixing just until combined. Stir in chocolate chips and walnuts.'
      },
      { 
        title: 'Form Cookies', 
        description: 'Drop rounded tablespoons of dough onto the prepared baking sheets, spacing them about 2 inches apart.'
      },
      { 
        title: 'Bake', 
        description: 'Bake for 9-12 minutes or until edges are golden brown but centers are still soft. Allow cookies to cool on the baking sheet for 2 minutes, then transfer to wire racks to cool completely.'
      }
    ],
    notes: [
      'For chewier cookies, use more brown sugar than granulated sugar.',
      'Chill the dough for at least 30 minutes before baking for thicker cookies.',
      'Store in an airtight container at room temperature for up to 5 days, or freeze for up to 3 months.'
    ],
    nutrition: {
      calories: '180 kcal',
      protein: '2g',
      carbs: '24g',
      fat: '10g',
      fiber: '1g'
    }
  },
  {
    id: 'r12',
    title: 'Quinoa Salad with Roasted Vegetables',
    description: 'A nutritious and colorful salad featuring protein-rich quinoa and a medley of roasted vegetables.',
    image: 'https://source.unsplash.com/random/300x200/?quinoa-salad',
    prepTime: 15,
    cookTime: 30,
    servings: 4,
    calories: 320,
    difficulty: 'Easy',
    category: 'lunch',
    rating: 4.7,
    featured: false,
    tags: ['vegetarian', 'vegan', 'lunch', 'salad', 'healthy', 'gluten-free'],
    ingredients: [
      { name: 'quinoa', quantity: '1', unit: 'cup', category: 'Dry Goods' },
      { name: 'vegetable broth', quantity: '2', unit: 'cups', category: 'Canned Goods' },
      { name: 'bell peppers', quantity: '2', unit: 'medium', category: 'Produce' },
      { name: 'zucchini', quantity: '1', unit: 'medium', category: 'Produce' },
      { name: 'red onion', quantity: '1', unit: 'small', category: 'Produce' },
      { name: 'cherry tomatoes', quantity: '1', unit: 'cup', category: 'Produce' },
      { name: 'olive oil', quantity: '3', unit: 'tbsp', category: 'Condiments' },
      { name: 'balsamic vinegar', quantity: '2', unit: 'tbsp', category: 'Condiments' },
      { name: 'lemon juice', quantity: '2', unit: 'tbsp', category: 'Produce' },
      { name: 'garlic', quantity: '2', unit: 'cloves', category: 'Produce' },
      { name: 'fresh parsley', quantity: '1/4', unit: 'cup', category: 'Produce' },
      { name: 'fresh mint', quantity: '2', unit: 'tbsp', category: 'Produce' },
      { name: 'salt', quantity: '1/2', unit: 'tsp', category: 'Spices' },
      { name: 'black pepper', quantity: '1/4', unit: 'tsp', category: 'Spices' },
      { name: 'feta cheese', quantity: '1/2', unit: 'cup', category: 'Dairy' },
      { name: 'pine nuts', quantity: '2', unit: 'tbsp', category: 'Dry Goods' }
    ],
    instructions: [
      { 
        title: 'Cook Quinoa', 
        description: 'Rinse quinoa thoroughly. In a medium saucepan, bring vegetable broth to a boil. Add quinoa, reduce heat to low, cover, and simmer for 15 minutes. Remove from heat and let stand for 5 minutes, then fluff with a fork.'
      },
      { 
        title: 'Roast Vegetables', 
        description: 'Preheat oven to 425°F (220°C). Cut bell peppers, zucchini, and red onion into 1-inch pieces. Toss with 1 tablespoon olive oil, salt, and pepper. Spread on a baking sheet and roast for 20-25 minutes, stirring halfway through, until tender and slightly charred.'
      },
      { 
        title: 'Prepare Dressing', 
        description: 'In a small bowl, whisk together remaining olive oil, balsamic vinegar, lemon juice, minced garlic, salt, and pepper.'
      },
      { 
        title: 'Toast Pine Nuts', 
        description: 'In a small dry skillet over medium heat, toast pine nuts until lightly golden, about 2-3 minutes, stirring constantly to prevent burning.'
      },
      { 
        title: 'Combine Ingredients', 
        description: 'In a large bowl, combine cooked quinoa, roasted vegetables, halved cherry tomatoes, chopped parsley, and mint. Pour dressing over salad and toss to combine.'
      },
      { 
        title: 'Add Toppings', 
        description: 'Sprinkle with crumbled feta cheese and toasted pine nuts just before serving.'
      }
    ],
    notes: [
      'For a vegan version, omit the feta cheese or substitute with a plant-based alternative.',
      'This salad can be served warm, at room temperature, or chilled.',
      'Leftovers keep well in the refrigerator for up to 3 days.'
    ],
    nutrition: {
      calories: '320 kcal',
      protein: '10g',
      carbs: '35g',
      fat: '18g',
      fiber: '7g'
    }
  }
];

export default sampleRecipes;
