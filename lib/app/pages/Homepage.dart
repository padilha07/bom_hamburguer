import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  static const Color primaryColor = Color(0xFFF5C842); // --primary
  static const Color backgroundColor = Color(0xFFFCFCFC); // --background
  static const Color foregroundColor = Color(0xFF1F2937); // --foreground
  static const Color mutedColor = Color(0xFF6B7280); // --muted-foreground
  static const Color cardColor = Color(0xFFFFFFFF); // --card

  final List<FeatureItem> features = [
    FeatureItem(
      icon: Icons.star,
      title: "Qualidade Premium",
      description: "Ingredientes frescos e selecionados",
    ),
    FeatureItem(
      icon: Icons.access_time,
      title: "Entrega Rápida", 
      description: "Seu pedido em até 30 minutos",
    ),
    FeatureItem(
      icon: Icons.local_shipping,
      title: "Delivery Grátis",
      description: "Acima de R\$ 35 em toda a cidade",
    ),
  ];

  @override
  void initState() {
    super.initState();
    
    // Configurar animações
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    ));

    // Iniciar animações
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            _buildHeroSection(context),
            
            // Features Section
            _buildFeaturesSection(context),
            
            // CTA Section
            _buildCTASection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 64.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isLargeScreen = constraints.maxWidth > 768;
              
              if (isLargeScreen) {
                // Layout desktop - 2 colunas
                return Row(
                  children: [
                    // Coluna do texto
                    Expanded(
                      child: _buildHeroTextContent(context, isLargeScreen),
                    ),
                    const SizedBox(width: 48),
                    // Coluna da imagem
                    Expanded(
                      child: _buildHeroImage(),
                    ),
                  ],
                );
              } else {
                // Layout mobile - 1 coluna
                return Column(
                  children: [
                    _buildHeroTextContent(context, isLargeScreen),
                    const SizedBox(height: 32),
                    _buildHeroImage(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeroTextContent(BuildContext context, bool isLargeScreen) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        crossAxisAlignment: isLargeScreen 
            ? CrossAxisAlignment.start 
            : CrossAxisAlignment.center,
        children: [
          // Título
          RichText(
            textAlign: isLargeScreen ? TextAlign.left : TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 768 ? 60 : 48,
                fontWeight: FontWeight.bold,
                color: foregroundColor,
                fontFamily: 'Inter',
              ),
              children: [
                const TextSpan(text: 'Bom '),
                TextSpan(
                  text: 'Hamburguer',
                  style: TextStyle(color: primaryColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Descrição
          Text(
            'Os melhores hambúrgueres artesanais da cidade. Feitos com ingredientes frescos e muito amor.',
            style: TextStyle(
              fontSize: 20,
              color: mutedColor,
              height: 1.5,
            ),
            textAlign: isLargeScreen ? TextAlign.left : TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Botões
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 480) {
                return Row(
                  mainAxisAlignment: isLargeScreen 
                      ? MainAxisAlignment.start 
                      : MainAxisAlignment.center,
                  children: [
                    _buildPrimaryButton(context),
                    const SizedBox(width: 16),
                    _buildSecondaryButton(context),
                  ],
                );
              } else {

                return Column(
                  children: [
                    _buildPrimaryButton(context),
                    const SizedBox(height: 16),
                    _buildSecondaryButton(context),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'images/hero_burger.jpg', // Você precisará adicionar a imagem
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Placeholder caso a imagem não carregue
              return Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    '🍔',
                    style: TextStyle(fontSize: 80),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/cardapio');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ver Cardápio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 20),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        side: BorderSide(color: Colors.grey[300]!),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        'Sobre Nós',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Column(
          children: [
            Text(
              'Por que escolher o Bom Hambúrguer?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 768) {
                  return Row(
                    children: features
                        .asMap()
                        .map((index, feature) => MapEntry(
                              index,
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: index == 1 ? 16 : 8,
                                  ),
                                  child: _buildFeatureCard(feature, index),
                                ),
                              ),
                            ))
                        .values
                        .toList(),
                  );
                } else {
                  return Column(
                    children: features
                        .asMap()
                        .map((index, feature) => MapEntry(
                              index,
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildFeatureCard(feature, index),
                              ),
                            ))
                        .values
                        .toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(FeatureItem feature, int index) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Card(
              color: cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      feature.icon,
                      size: 48,
                      color: primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      feature.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: foregroundColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      feature.description,
                      style: TextStyle(
                        color: mutedColor,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCTASection(BuildContext context) {
    return Container(
      color: cardColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          children: [
            Text(
              'Pronto para experimentar?',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: foregroundColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Faça seu pedido agora e receba em casa quentinho e delicioso!',
              style: TextStyle(
                fontSize: 20,
                color: mutedColor,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cardapio');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: foregroundColor,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Fazer Pedido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FeatureItem {
  final IconData icon;
  final String title;
  final String description;

  FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
