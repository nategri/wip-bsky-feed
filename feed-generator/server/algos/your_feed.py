from datetime import datetime
from typing import Optional

from server import config
from server.database import Post

uri = config.YOUR_FEED_URI


def handler(cursor: Optional[str], limit: int) -> dict:
    #posts = Post.select().order_by(Post.indexed_at.desc()).order_by(Post.cid.desc()).limit(limit)

    #posts = Post.select().order_by(Post.indexed_at.desc()).limit(limit)

    if cursor:
        cursor_parts = cursor.split('::')
        if len(cursor_parts) != 2:
            raise ValueError('Malformed cursor')

        indexed_at, cid = cursor_parts
        indexed_at = datetime.fromtimestamp(int(indexed_at) / 1000)
        posts = Post.select().order_by(Post.indexed_at.desc()).where(Post.reply_parent == None).where(Post.indexed_at <= indexed_at).where(Post.cid < cid).limit(limit)
    else:
        posts = Post.select().order_by(Post.indexed_at.desc()).where(Post.reply_parent == None).limit(limit)


    cursor = None
    last_post = posts[-1] if posts else None
    if last_post:
        cursor = f'{int(last_post.indexed_at.timestamp() * 1000)}::{last_post.cid}'

    feed_posts = posts.order_by(Post.indexed_at.desc())
    feed = [{'post': fp.uri} for fp in feed_posts]

    return {
        'cursor': cursor,
        'feed': feed
    }
