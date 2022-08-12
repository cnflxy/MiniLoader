#ifndef _LIST_H_
#define _LIST_H_ 1

#include "types.h"

struct list_entry
{
    struct list_entry *prev;
    struct list_entry *next;
};

void init_list(struct list_entry *head);
bool list_empty(const struct list_entry *head);
void insert_head(struct list_entry *head, struct list_entry *entry);
void insert_tail(struct list_entry *head, struct list_entry *entry);
struct list_entry *remove_head(struct list_entry *head);
struct list_entry *remove_tail(struct list_entry *head);
void remove_entry(struct list_entry *entry);

#endif
