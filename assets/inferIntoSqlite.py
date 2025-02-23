import sqlite3

def search_word(word):
    # Connect to SQLite database
    conn = sqlite3.connect('assets\mini_dictionary.db')
    cursor = conn.cursor()

    # Search for the word in the dictionary table
    cursor.execute('''
    SELECT word, ipa, tpa, english_definition, tamil_definition
    FROM dictionary
    WHERE word = ?
    ''', (word,))

    # Fetch the result
    result = cursor.fetchone()

    conn.close()

    # Check if the word was found
    if result:
        return {
            'word': result[0],
            'ipa': result[1],
            'tpa': result[2],
            'english_definition': result[3],
            'tamil_definition': result[4]
        }
    else:
        return None

# Example usage
word_to_search = 'aa'
result = search_word(word_to_search)

if result:
    print(f"Word: {result['word']}")
    print(f"IPA: {result['ipa']}")
    print(f"TPA: {result['tpa']}")
    print(f"English Definition: {result['english_definition']}")
    print(f"Tamil Definition: {result['tamil_definition']}")
else:
    print(f"The word '{word_to_search}' was not found in the dictionary.")