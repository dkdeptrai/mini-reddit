module ApplicationHelper
  def vote_paths(votable)
    if votable.is_a?(Post)
      {
        upvote_path: upvote_post_path(votable, post_id: votable.id),
        downvote_path: downvote_post_path(votable, post_id: votable.id),
        turbo_frame: dom_id(votable)
      }
    elsif votable.is_a?(Comment)
      commentable = votable.commentable
      {
        upvote_path: upvote_post_comment_path(votable.commentable, votable, comment_id: votable.id),
        downvote_path: downvote_post_comment_path(votable.commentable, votable, comment_id: votable.id),
        turbo_frame: dom_id(votable)
      }
    end
  end
end
