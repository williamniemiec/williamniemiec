import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/message.dart';
import '../../auth/providers/auth_provider.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<Message> _messages = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    // Simulate loading messages
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _messages = _getMockMessages();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Mensagens'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingState() : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16),
          Text(
            'Carregando mensagens...',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final filteredMessages = _getFilteredMessages();
    
    if (filteredMessages.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        // Filter chips
        _buildFilterChips(),
        
        // Messages list
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadMessages,
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final message = filteredMessages[index];
                return _buildMessageCard(message);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'key': 'all', 'label': 'Todas'},
      {'key': 'unread', 'label': 'Não lidas'},
      {'key': 'important', 'label': 'Importantes'},
      {'key': 'system', 'label': 'Sistema'},
    ];

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter['key'];
          
          return Container(
            margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
            child: FilterChip(
              label: Text(filter['label'] as String),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['key'] as String;
                });
              },
              selectedColor: AppColors.primary.withOpacity(0.2),
              checkmarkColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMessageCard(Message message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: message.isRead ? AppColors.surface : AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        elevation: message.isRead ? 1 : 3,
        shadowColor: AppColors.cardShadow,
        child: InkWell(
          onTap: () => _openMessage(message),
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.defaultPadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              border: message.isRead 
                  ? null 
                  : Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  children: [
                    // Message type icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getMessageTypeColor(message.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getMessageTypeIcon(message.type),
                        color: _getMessageTypeColor(message.type),
                        size: 20,
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Title and sender
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  message.title,
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: message.isRead ? FontWeight.w500 : FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              // Priority indicator
                              if (message.isHighPriority) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: message.isUrgent 
                                        ? AppColors.error.withOpacity(0.1)
                                        : AppColors.warning.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    message.priorityDescription,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: message.isUrgent ? AppColors.error : AppColors.warning,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          
                          const SizedBox(height: 2),
                          
                          Text(
                            message.sender,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Time and unread indicator
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.timeAgo,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        
                        const SizedBox(height: 4),
                        
                        if (!message.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Message preview
                Text(
                  message.preview,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Attachments indicator
                if (message.hasAttachments) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.attach_file,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${message.attachments!.length} anexo(s)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
                
                // Action button
                if (message.hasAction) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _handleMessageAction(message),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(message.actionText ?? 'Ver mais'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.message_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Nenhuma mensagem encontrada',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Suas notificações e comunicados do SUS aparecerão aqui.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar Mensagens'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Todas'),
                leading: Radio<String>(
                  value: 'all',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Não lidas'),
                leading: Radio<String>(
                  value: 'unread',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Importantes'),
                leading: Radio<String>(
                  value: 'important',
                  groupValue: _selectedFilter,
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value!;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openMessage(Message message) {
    if (!message.isRead) {
      setState(() {
        final index = _messages.indexWhere((m) => m.id == message.id);
        if (index != -1) {
          _messages[index] = message.markAsRead();
        }
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message.title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'De: ${message.sender}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Data: ${message.formattedSentDateTime}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  message.content,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
            if (message.hasAction)
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _handleMessageAction(message);
                },
                child: Text(message.actionText ?? 'Ação'),
              ),
          ],
        );
      },
    );
  }

  void _handleMessageAction(Message message) {
    // Handle message action based on the action URL or type
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ação da mensagem: ${message.actionText}'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  List<Message> _getFilteredMessages() {
    switch (_selectedFilter) {
      case 'unread':
        return _messages.where((m) => !m.isRead).toList();
      case 'important':
        return _messages.where((m) => m.isImportant || m.isHighPriority).toList();
      case 'system':
        return _messages.where((m) => m.type.toLowerCase() == 'system').toList();
      default:
        return _messages;
    }
  }

  IconData _getMessageTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
      case 'consulta':
        return Icons.calendar_today;
      case 'exam':
      case 'exame':
        return Icons.science;
      case 'vaccination':
      case 'vacinacao':
        return Icons.vaccines;
      case 'medication':
      case 'medicamento':
        return Icons.medication;
      case 'health_alert':
      case 'alerta_saude':
        return Icons.warning;
      case 'campaign':
      case 'campanha':
        return Icons.campaign;
      case 'system':
      case 'sistema':
        return Icons.settings;
      default:
        return Icons.message;
    }
  }

  Color _getMessageTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'appointment':
      case 'consulta':
        return AppColors.appointmentColor;
      case 'exam':
      case 'exame':
        return AppColors.examColor;
      case 'vaccination':
      case 'vacinacao':
        return AppColors.vaccineColor;
      case 'medication':
      case 'medicamento':
        return AppColors.medicationColor;
      case 'health_alert':
      case 'alerta_saude':
        return AppColors.warning;
      case 'campaign':
      case 'campanha':
        return AppColors.info;
      case 'system':
      case 'sistema':
        return AppColors.textSecondary;
      default:
        return AppColors.primary;
    }
  }

  List<Message> _getMockMessages() {
    final userId = Provider.of<AuthProvider>(context, listen: false).currentUser?.id ?? 'demo_user';
    
    return [
      Message(
        id: 'msg_1',
        userId: userId,
        title: 'Resultado de exame disponível',
        content: 'Seu exame de sangue realizado em 15/12/2023 já está disponível para consulta. Acesse a seção de exames para visualizar os resultados completos.',
        type: 'exam',
        priority: 'high',
        sender: 'Laboratório Central - SUS',
        senderInstitution: 'Ministério da Saúde',
        sentDate: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        isImportant: true,
        actionUrl: '/exams',
        actionText: 'Ver Resultado',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      Message(
        id: 'msg_2',
        userId: userId,
        title: 'Consulta agendada confirmada',
        content: 'Sua consulta com Dr. João Silva foi confirmada para 20/12/2023 às 14:00. Local: UBS Centro - Brasília/DF. Lembre-se de levar um documento com foto.',
        type: 'appointment',
        priority: 'medium',
        sender: 'UBS Centro',
        senderInstitution: 'Secretaria de Saúde - DF',
        sentDate: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        actionUrl: '/appointments',
        actionText: 'Ver Detalhes',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      Message(
        id: 'msg_3',
        userId: userId,
        title: 'Campanha de Vacinação - Influenza 2024',
        content: 'A campanha de vacinação contra a gripe já começou! Procure a unidade de saúde mais próxima e mantenha sua vacinação em dia. Grupos prioritários têm preferência.',
        type: 'campaign',
        priority: 'medium',
        sender: 'Ministério da Saúde',
        senderInstitution: 'Governo Federal',
        sentDate: DateTime.now().subtract(const Duration(days: 3)),
        isRead: false,
        isImportant: false,
        actionUrl: '/vaccines',
        actionText: 'Saiba Mais',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      Message(
        id: 'msg_4',
        userId: userId,
        title: 'Medicamento disponível na Farmácia Popular',
        content: 'O medicamento Losartana 50mg prescrito pelo Dr. Maria Santos está disponível para retirada na Farmácia Popular. Válido até 25/12/2023.',
        type: 'medication',
        priority: 'high',
        sender: 'Farmácia Popular',
        senderInstitution: 'Ministério da Saúde',
        sentDate: DateTime.now().subtract(const Duration(days: 2)),
        isRead: false,
        isImportant: true,
        actionUrl: '/medications',
        actionText: 'Ver Localização',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      
      Message(
        id: 'msg_5',
        userId: userId,
        title: 'Atualização do Sistema Conecte SUS',
        content: 'O aplicativo foi atualizado com novas funcionalidades e melhorias de segurança. Reinicie o app para aplicar as atualizações.',
        type: 'system',
        priority: 'low',
        sender: 'Equipe Conecte SUS',
        senderInstitution: 'DATASUS',
        sentDate: DateTime.now().subtract(const Duration(days: 5)),
        isRead: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}