create table users (
    user_id int identity(1,1) primary key,
    username nvarchar(50) not null unique,
    email nvarchar(100) not null unique,
    hash_password nvarchar(100) not null,
    created_at datetime not null default getdate()
);

create table posts (
    post_id int identity(1, 1) primary key,
    user_id int not null,
    title nvarchar(50) not null,
    description nvarchar(255) not null,
    photo_url nvarchar(255) not null,
    created_at datetime not null default getdate(),
    constraint fk_posts_users foreign key (user_id) references users(user_id)
);

create table friends (
    user_id int not null,
    friend_id int not null,
    status nvarchar(50) not null default 'pending', -- Allowed values: 'pending', 'accepted', 'rejected',
    created_at datetime not null default getdate(),
    constraint pk_friends primary key (user_id, friend_id),
    constraint ck_status check (status in ('pending', 'accepted', 'rejected', 'blocked')),
    constraint fk_friends_user foreign key (user_id) references users(user_id),
    constraint fk_friends_friend foreign key (friend_id) references users(user_id)
);

create table chats (
    chat_id int identity(1, 1) primary key,
    user1_id int not null,
    user2_id int not null,
    created_at datetime not null default getdate(),
    constraint fk_chats_user1 foreign key (user1_id) references users(user_id),
    constraint fk_chats_user2 foreign key (user2_id) references users(user_id)
);

create table messages (
    message_id int identity(1, 1) primary key,
    chat_id int not null,
    sender_id int not null,
    receiver_id int not null,
    content nvarchar(255) not null,
    send_at datetime not null default getdate(),
    constraint fk_messages_chat foreign key (chat_id) references chats(chat_id),
    constraint fk_messages_sender foreign key (sender_id) references users(user_id),
    constraint fk_messages_receiver foreign key (receiver_id) references users(user_id)
);

create table stories (
    story_id int identity(1, 1) primary key,
    user_id int not null,
    media_url nvarchar(255) not null,
    caption nvarchar(500) not null,
    created_at datetime not null default getdate(),
    expires_at datetime not null,
    constraint fk_stories_user foreign key (user_id) references users(user_id),
    constraint ck_stories_expires check (expires_at > created_at)
);

