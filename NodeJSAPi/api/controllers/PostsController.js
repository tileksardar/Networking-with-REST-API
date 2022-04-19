//dummy database



//     const post1 = {id: 1, 
//     title: 'POST TITLE 1',
//      body:'HERE IS MY BODY'}
     
//     const post2 = {id: 2, 
//         title: 'TITLE 2',
//          body:'BODY BODY'}

//     const post3 = {id: 3, 
//             title: 'TITLE 3',
//              body:'BODY BODY BODY'}

//  const allPosts = [post1,post2, post3]



module.exports = {

    posts: async function(req,res){
        try{
            const posts = await Post.find()
            res.send(posts)
        }
        catch(err){
            res.serverError(err.toString())
        }

      

    },
   // create: function(req,res){
//         const title = req.body.title
//         const postBody = req.body.postBody

//         sails.log.debug('title: '+ title)
//         sails.log.debug('body: '+ postBody)

// Post.create({title: title, body: postBody}).exec(function(err){
//     if (err){
//         return res.serverError(err.toString())
//     }
//     console.log('Finished creating post object')

//      return res.redirect('/home')
//     //return res.end()
// })
      
//     },

    findById: function(req, res){
        const postId = req.param('postId')

        const filteredPosts = allPosts
        .filter(p => {return p.id == postId})

        if (filteredPosts.length > 0){
            res.send(filteredPosts[0])
        }else{
            res.send('Failed to find post by id: ' + postId)
        }
    },
    // delete: async function(req,res){
    //     const postId = req.param('postId')
    //    await Post.destroy({id: postId})

    //     res.send('Finished deleting post')
    // }
}
