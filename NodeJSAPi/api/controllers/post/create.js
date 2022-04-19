
module.exports = {


  friendlyName: 'Create',


  description: 'Create post.',


  inputs: {
    title:{
      description: 'Title of post object',
      type: 'string',
      required: true
    }, 
    postBody:{
      type: 'string', required: true
    }

  },



  exits: {

  },


  fn: async function (inputs) {
     console.log('We are now inside of post/create action')

     await Post.create({title: inputs.title, body: inputs.postBody})
     return;

  }


};
