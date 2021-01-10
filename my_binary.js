const yargs = require('yargs');

const { foo } = yargs.option('foo', { required: true }).argv;
console.log(foo);
