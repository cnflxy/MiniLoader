#include "list.h"

void init_list(struct list_entry *head)
{
    head->prev = head;
    head->next = head;
}

bool list_empty(const struct list_entry *head)
{
    return head->next == head;
}

void insert_head(struct list_entry *head, struct list_entry *entry)
{
    entry->next = head->next;
    entry->prev = head;
    head->next = entry;
}

void insert_tail(struct list_entry *head, struct list_entry *entry)
{
    entry->prev = head->prev;
    entry->next = head;
    head->prev = entry;
}

struct list_entry *remove_head(struct list_entry *head)
{
    // if(list_empty(head)) return head;

    struct list_entry *entry = head->next;
    head->next = entry->next;
    head->next->prev = head;
    return entry;
}

struct list_entry *remove_tail(struct list_entry *head)
{
    struct list_entry *entry = head->prev;
    head->prev = entry->prev;
    head->prev->next = head;
    return entry;
}

void remove_entry(struct list_entry *entry)
{
    remove_head(entry->prev);

    // struct list_entry *tmp_head = entry->prev;
    // tmp->prev = entry->prev;
    // entry->prev->next = tmp;
}
