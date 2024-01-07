#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_SIZE 1000

// Function prototypes
void readFile(const char *filename, char **content);
void replaceWord(const char *originalWord, const char *newWord, char **content);
void writeFile(const char *filename, const char *content);
int isSameWord(const char *word1, const char *word2);
void processFile(const char *filename, const char *originalWord, const char *newWord);

/* int main()
{
    char filename[100], originalWord[100], newWord[100];

    // Get user input
    printf("Enter the filename: ");
    scanf("%99s", filename);
    printf("Enter the original word: ");
    scanf("%99s", originalWord);
    printf("Enter the new word: ");
    scanf("%99s", newWord);

    // Process the file
    processFile(filename, originalWord, newWord);

    return 0;
} */

void processFile(const char *filename, const char *originalWord, const char *newWord)
{
    char *content = NULL;
    readFile(filename, &content);
    if (content != NULL)
    {
        replaceWord(originalWord, newWord, &content);
        writeFile(filename, content);
        printf("File saved.\n");
        free(content); // Free the memory allocated in replaceWord
    }
    else
    {
        printf("Failed to read the file.\n");
    }
}

void readFile(const char *filename, char **content)
{
    FILE *file = fopen(filename, "r");
    if (file == NULL)
    {
        *content = NULL;
        return;
    }

    fseek(file, 0, SEEK_END);
    long length = ftell(file);
    fseek(file, 0, SEEK_SET);

    *content = (char *)malloc(length + 1);
    if (*content)
    {
        fread(*content, 1, length, file);
        (*content)[length] = '\0';
    }

    fclose(file);
}

void replaceWord(const char *originalWord, const char *newWord, char **content)
{
    int contentLength = strlen(*content);
    int newWordLength = strlen(newWord);
    int oldWordLength = strlen(originalWord);

    // Estimation de la taille maximale nécessaire
    int maxNewLength = contentLength + (newWordLength - oldWordLength) * contentLength;
    char *result = (char *)malloc(maxNewLength + 1);
    if (!result)
    {
        return; // Échec de l'allocation de mémoire
    }

    char *currentPos = *content;
    char *newPos = result;
    while (*currentPos)
    {
        // Si le mot actuel correspond à originalWord
        if (strstr(currentPos, originalWord) == currentPos && isSameWord(originalWord, currentPos))
        {
            strcpy(newPos, newWord);
            currentPos += oldWordLength;
            newPos += newWordLength;
        }
        else
        {
            *newPos++ = *currentPos++;
        }
    }
    *newPos = '\0'; // Fin de la nouvelle chaîne

    free(*content);    // Libération de l'ancienne mémoire
    *content = result; // Mise à jour du pointeur
}

void writeFile(const char *filename, const char *content)
{
    FILE *file = fopen(filename, "w");
    if (file != NULL)
    {
        fputs(content, file);
        fclose(file);
    }
}

int isSameWord(const char *word1, const char *word2)
{
    return strncmp(word1, word2, strlen(word1)) == 0;
}
