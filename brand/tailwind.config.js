/** Diusframi — preset Tailwind v3
 *  module.exports = { presets: [require('./brand/tailwind.config.js')] }
 */
module.exports = {
  theme: {
    extend: {
      colors: {
        navy: { 50:'#F2F4F9',100:'#DDE1EE',300:'#8E97BC',600:'#2A3C8F',700:'#1B2A6F',800:'#111C4E',900:'#0A1236', DEFAULT:'#111C4E' },
        orange: { 100:'#FFE3D6',300:'#FF9466',500:'#FF5100',600:'#E04700',700:'#B33900', DEFAULT:'#FF5100' },
        electric: { 100:'#D9E4FF',500:'#0053FF',600:'#0043CC', DEFAULT:'#0053FF' },
        brandyellow: { 100:'#FFF4D6',500:'#FFD040',600:'#D6A400', DEFAULT:'#FFD040' },
        success:'#0E8F5B', danger:'#D92D20'
      },
      fontFamily: { sans: ['Inter', '-apple-system', 'Segoe UI', 'Roboto', 'sans-serif'] },
      fontSize: {
        display: ['48px', { lineHeight: '56px', letterSpacing: '-0.02em', fontWeight: '300' }],
        title:   ['36px', { lineHeight: '44px', fontWeight: '700' }],
        heading: ['28px', { lineHeight: '36px', fontWeight: '500' }],
        lead:    ['24px', { lineHeight: '32px', fontWeight: '500' }],
        body:    ['20px', { lineHeight: '30px' }]
      },
      borderRadius: { md:'10px', lg:'12px', xl:'20px' },
      boxShadow: {
        card: '0 4px 16px rgba(17,28,78,.10)',
        float: '0 16px 40px rgba(17,28,78,.14)'
      },
      backgroundImage: {
        'brand-gradient': 'linear-gradient(135deg,#111C4E 0%,#0053FF 55%,#FF5100 100%)',
        'brand-gradient-soft': 'linear-gradient(135deg,#111C4E 0%,#0053FF 100%)'
      }
    }
  }
};
